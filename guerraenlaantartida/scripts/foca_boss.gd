extends PathFollow2D

@export var velocidad = 0.03
var velocidad_original = 0.03
var atacando = false
var objetivo = null
@export var vida = 2500
@export var daño = 150
@export var armadura = 0
@export var vuela = false

@onready var foca_escena = preload("res://escenas/foca_leopardo.tscn")
@onready var foca_escena_chaleco = preload("res://escenas/foca_leopardo_chaleco.tscn")
@onready var foca_escena_chaleco_casco = preload("res://escenas/foca_leopardo_chaleco_casco.tscn")
@onready var foca_escena_blindada = preload("res://escenas/foca_blindada.tscn")
@onready var foca_escena_payaso = preload("res://escenas/foca_payaso.tscn")
@onready var foca_escena_hielo = preload("res://escenas/foca_hielo.tscn")
@onready var foca_escena_ignea = preload("res://escenas/foca_ignea.tscn")
@onready var boss_escena = preload("res://escenas/foca_boss.tscn")

var timer_fase: Timer

# Control de fases y movimiento
var detenido = false
var fase = 1

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
	if detenido:
		return

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

				if not area.is_in_group("proyectil_hielo") and not area.is_in_group("proyectil_fuego"):
					daño_recibido *= 0.5

				if armadura > 0:
					if daño_recibido <= armadura:
						armadura -= daño_recibido
						daño_recibido = 0
					else:
						daño_recibido -= armadura
						armadura = 0

				vida -= daño_recibido

		if area.is_in_group("proyectil_fuego"):
			if congelado:
				congelado = false
				timer_congelado.stop()
				quemado = false
				velocidad = velocidad_original * 0.8
				velocidad_reducida_temporal = true
				timer_velocidad_reducida.start()
				if not atacando:
					$AnimatedSprite2D.play("Moverse")
			else:
				aplicar_quemadura()

		elif area.is_in_group("proyectil_hielo"):
			if quemado:
				vida -= 10
				quemado = false
				timer_quemadura.stop()
			else:
				bolas_recibidas += 1
				if bolas_recibidas >= 4:
					aplicar_congelado()
				elif congelado:
					timer_congelado.stop()
					timer_congelado.wait_time = tiempo_congelacion
					timer_congelado.start()
					$AnimatedSprite2D.play("Congelado")

func aplicar_quemadura():
	if not quemado:
		quemado = true
		tiempo_quemado = 3
		timer_quemadura.start()
	else:
		tiempo_quemado = 3

func aplicar_congelado():
	bolas_recibidas = 0
	if not congelado:
		congelado = true
		velocidad = 0

	timer_congelado.wait_time = tiempo_congelacion
	timer_congelado.start()
	$AnimatedSprite2D.play("Congelado")

func _on_timer_quemadura_timeout():
	if tiempo_quemado > 0:
		vida -= daño_por_quemadura
		tiempo_quemado -= 1
	else:
		quemado = false
		timer_quemadura.stop()

func _on_timer_congelado_timeout():
	congelado = false
	velocidad = velocidad_original
	if not atacando:
		$AnimatedSprite2D.play("Moverse")

func _on_timer_velocidad_reducida_timeout():
	if velocidad_reducida_temporal:
		velocidad = velocidad_original
		velocidad_reducida_temporal = false

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

func set_detenido(valor: bool) -> void:
	detenido = valor
	if detenido:
		if "Quieto" in $AnimatedSprite2D.sprite_frames.get_animation_names():
			$AnimatedSprite2D.play("Quieto")
	else:
		if not atacando and not congelado:
			$AnimatedSprite2D.play("Moverse")

func hacer_fase():
	if fase == 1:
		timer_fase = Timer.new()
		timer_fase.wait_time = 5.0
		timer_fase.one_shot = false
		add_child(timer_fase)
		timer_fase.connect("timeout", Callable(self, "_on_timer_fase_1_timeout"))
		timer_fase.start()
		print("🚨 Fase 1 activada: generación de focas cada 5 segundos")

func _on_timer_fase_1_timeout():
	var focas = [
		foca_escena_chaleco,
		foca_escena_chaleco_casco,
		foca_escena_blindada,
		foca_escena_payaso,
		foca_escena_hielo,
		foca_escena_ignea
	]

	var foca_escena = focas[randi() % focas.size()]
	var nueva_foca = foca_escena.instantiate()

	var nivel = get_tree().root.get_node("Nivel")
	if nivel:
		var carril_id = str(1 + randi() % 5)
		var carril = nivel.get_node(carril_id)
		if carril:
			carril.add_child(nueva_foca)
			nueva_foca.rotation_degrees = 90
			nueva_foca.progress_ratio = 0
