extends PathFollow2D

@export var velocidad = 0.005
var velocidad_original = 0.005
var atacando = false
var objetivo = null
@export var vida = 300
@export var daño = 40
@export var armadura = 100
@export var vuela = false

# 🔥 Quemadura
var quemado = false
var tiempo_quemado = 3
var daño_por_quemadura = 5
var timer_quemadura: Timer

# ❄️ Congelación
var bolas_recibidas = 0
var congelado = false
var timer_congelado: Timer
var tiempo_congelacion = 3.0

# 🐢 Reducción temporal de velocidad tras descongelación
var velocidad_reducida_temporal = false
var timer_velocidad_reducida: Timer

func _ready() -> void:
	rotation = 0
	$AnimatedSprite2D.play("Moverse")
	

	# Timer quemadura
	timer_quemadura = Timer.new()
	timer_quemadura.wait_time = 1.0
	timer_quemadura.one_shot = false
	add_child(timer_quemadura)
	timer_quemadura.connect("timeout", Callable(self, "_on_timer_quemadura_timeout"))

	# Timer congelación
	timer_congelado = Timer.new()
	timer_congelado.wait_time = tiempo_congelacion
	timer_congelado.one_shot = true
	add_child(timer_congelado)
	timer_congelado.connect("timeout", Callable(self, "_on_timer_congelado_timeout"))

	# Timer velocidad reducida
	timer_velocidad_reducida = Timer.new()
	timer_velocidad_reducida.wait_time = 3.0
	timer_velocidad_reducida.one_shot = true
	add_child(timer_velocidad_reducida)
	timer_velocidad_reducida.connect("timeout", Callable(self, "_on_timer_velocidad_reducida_timeout"))

	velocidad_original = velocidad

func _process(_delta):
	if objetivo and not is_instance_valid(objetivo):
		atacando = false
		objetivo = null
		if not congelado:
			$AnimatedSprite2D.play("Moverse")

	if vida <= 0:
		$Area2D.hide()
		$AnimatedSprite2D.play("Morir")
		await get_tree().create_timer(0.5).timeout
		queue_free()

	if progress_ratio == 1:
		queue_free()
		get_tree().root.get_node("Nivel").terminarjuego()

	if not atacando and not congelado and $AnimatedSprite2D.animation != "Congelado":
		progress_ratio += velocidad * _delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("pinguino") and not atacando:
		objetivo = area.get_parent()
		atacando = true
		$AnimatedSprite2D.play("Ataque")
		$Timer.start()
	elif area.is_in_group("proyectil"):
		var proyectil = area.get_parent()
		if proyectil.has_method("get"):
			if "daño" in proyectil:
				var daño_recibido = proyectil.daño
				if armadura > 0:
					if daño_recibido <= armadura:
						armadura -= daño_recibido
						daño_recibido = 0
					else:
						daño_recibido -= armadura
						armadura = 0
				vida -= daño_recibido
				print("Daño recibido:", proyectil.daño, " Armadura restante:", armadura, " Vida restante:", vida)
		if area.is_in_group("proyectil_fuego"):
			if congelado:
				print("🔥❄️ Disparo de fuego sobre foca congelada. Se descongela con penalización de velocidad.")
				congelado = false
				timer_congelado.stop()
				quemado = false  # No se quema en este caso
				velocidad = velocidad_original * 0.8
				velocidad_reducida_temporal = true
				timer_velocidad_reducida.start()
				if not atacando:
					$AnimatedSprite2D.play("Moverse")
			else:
				aplicar_quemadura()

		# ❄️ Disparo de hielo
		elif area.is_in_group("proyectil_hielo"):
			if quemado:
				vida -= 10
				print("❄️🔥 Foca quemada recibe hielo. Se elimina quemadura y se aplica daño extra. No se congela.")
				quemado = false
				timer_quemadura.stop()
			else:
				bolas_recibidas += 1
				print("❄️ Bola de hielo recibida. Total:", bolas_recibidas)
				if bolas_recibidas >= 4:
					aplicar_congelado()
				elif congelado:
					# 🔁 Reaplicar congelación si ya estaba congelada
					print("🔁 Foca ya congelada. Reiniciando duración de congelación.")
					timer_congelado.stop()
					timer_congelado.wait_time = tiempo_congelacion
					timer_congelado.start()
					$AnimatedSprite2D.play("Congelado")

func aplicar_quemadura():
	if not quemado:
		quemado = true
		tiempo_quemado = 3
		timer_quemadura.start()
		print("🔥 Foca quemada")
	else:
		tiempo_quemado = 3
		print("🔥 Quemadura reiniciada")

func aplicar_congelado():
	bolas_recibidas = 0
	if not congelado:
		congelado = true
		velocidad = 0
		print("❄️ Foca congelada por", tiempo_congelacion, "segundos")
	else:
		print("🔁 Foca ya congelada. Reiniciando congelación")

	timer_congelado.wait_time = tiempo_congelacion
	timer_congelado.start()
	$AnimatedSprite2D.play("Congelado")

func _on_timer_quemadura_timeout():
	if tiempo_quemado > 0:
		vida -= daño_por_quemadura
		print("🔥 Daño por quemadura:", daño_por_quemadura, " Vida restante:", vida)
		tiempo_quemado -= 1
	else:
		quemado = false
		timer_quemadura.stop()
		print("🔥 Quemadura terminada")

func _on_timer_congelado_timeout():
	congelado = false
	velocidad = velocidad_original
	if not atacando:
		$AnimatedSprite2D.play("Moverse")
	print("❄️ Congelación terminada")

func _on_timer_velocidad_reducida_timeout():
	if velocidad_reducida_temporal:
		velocidad = velocidad_original
		velocidad_reducida_temporal = false
		print("🐢 Penalización de velocidad terminada")

func _on_area_2d_area_exited(area):
	if area.get_parent() == objetivo:
		atacando = false
		objetivo = null
		if not congelado:
			$AnimatedSprite2D.play("Moverse")

func _on_timer_timeout():
	if objetivo and is_instance_valid(objetivo):
		objetivo.recibir_daño(daño)
		$Timer.start()
	else:
		atacando = false
		objetivo = null
		if not congelado:
			$AnimatedSprite2D.play("Moverse")

func actualiza_tiempo_congelado(tiempo_nuevo: float) -> void:
	tiempo_congelacion = tiempo_nuevo
	print("⏱️ Tiempo de congelación actualizado a:", tiempo_congelacion)
