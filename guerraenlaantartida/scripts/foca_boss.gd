extends PathFollow2D

@export var velocidad = 0.002
var velocidad_original = 0.002
var atacando = false
var objetivo = null
@export var vida = 5000
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

@export var proyectil_fuego_boss = preload("res://escenas/bola_de_fuego.tscn")
@export var proyectil_hielo_boss = preload("res://escenas/bola_de_hielo.tscn")

var timer_fase: Timer
var fase = 1
var detenido = false

var timer_ataque_final: Timer

var tiempo_fase_1 = 6

func _ready() -> void:
	rotation = 0
	$AnimatedSprite2D.play("Moverse")
	velocidad_original = velocidad
	hacer_fase()
func _process(_delta):
	if vida <4000 :
		tiempo_fase_1 = 4
	if vida < 3000 :
		tiempo_fase_1 = 2
	if vida < 2500 :
		tiempo_fase_1 = 1
	
	if vida < 2000 and fase == 1:
		hide()
		fase = 2
		hacer_fase()
	elif vida <= 0:
		$Area2D.hide()
		$AnimatedSprite2D.play("Morir")
		await get_tree().create_timer(0.5).timeout
		queue_free()
		var nivel = get_tree().root.get_node("Nivel")
		nivel.terminar_boss()

	if progress_ratio == 1:
		queue_free()
		get_tree().root.get_node("Nivel").terminarjuego()

	if detenido:
		return

	if objetivo and not is_instance_valid(objetivo):
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")

	if not atacando:
		progress_ratio += velocidad * _delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("pinguino") and not atacando:
		objetivo = area.get_parent()
		atacando = true
		$AnimatedSprite2D.play("Ataque")
		$Timer.start()
	elif area.is_in_group("proyectil"):
		if fase == 2 or fase == 3:
			return
		var proyectil = area.get_parent()
		if proyectil.has_method("get"):
			if "daño" in proyectil:
				var daño_recibido = proyectil.daño

				# ⚠️ Reducir daño si no es proyectil de fuego ni de hielo
				if not area.is_in_group("proyectil_hielo") and not area.is_in_group("proyectil_fuego"):
					daño_recibido *= 0.5

				# Aplicar armadura
				if armadura > 0:
					if daño_recibido <= armadura:
						armadura -= daño_recibido
						daño_recibido = 0
					else:
						daño_recibido -= armadura
						armadura = 0

				vida -= daño_recibido

func _on_area_2d_area_exited(area):
	if area.get_parent() == objetivo:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")

func _on_timer_timeout():
	if objetivo and is_instance_valid(objetivo):
		objetivo.recibir_daño(daño)
		$Timer.start()
	else:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")

func set_detenido(valor: bool) -> void:
	detenido = valor
	if detenido:
		if "Quieto" in $AnimatedSprite2D.sprite_frames.get_animation_names():
			$AnimatedSprite2D.play("Quieto")
	else:
		if not atacando:
			$AnimatedSprite2D.play("Moverse")

func hacer_fase():
	if timer_fase:
		timer_fase.stop()
		timer_fase.queue_free()
	
	timer_fase = Timer.new()
	add_child(timer_fase)

	match fase:
		1:
			var nivel = get_tree().root.get_node("Nivel")
			if nivel.has_node("AnimationPlayer"):
				nivel.get_node("AnimationPlayer").play("fase_1")
			await get_tree().create_timer(1.5).timeout
			show()
			print("Fase 1")
			timer_fase.wait_time = tiempo_fase_1
			timer_fase.connect("timeout", Callable(self, "_on_timer_fase_1_timeout"))
			timer_fase.start()
		2:
			hide()
			var nivel = get_tree().root.get_node("Nivel")
			if nivel.has_node("AnimationPlayer"):
				nivel.get_node("AnimationPlayer").play("fase_2")
			await get_tree().create_timer(1.5).timeout
			print("Fase 2")
			timer_fase.wait_time = 4
			timer_fase.connect("timeout", Callable(self, "_on_timer_fase_2_timeout"))
			timer_fase.start()
			await get_tree().create_timer(90.0).timeout
			fase = 3
			hacer_fase()
		3:
			var nivel = get_tree().root.get_node("Nivel")
			if nivel.has_node("AnimationPlayer"):
				nivel.get_node("AnimationPlayer").play("fase_3")
			await get_tree().create_timer(1.5).timeout
			print("Fase 3")
			hide()
			timer_fase.wait_time = 5
			timer_fase.connect("timeout", Callable(self, "_on_timer_fase_3_timeout"))
			timer_fase.start()
			await get_tree().create_timer(90.0).timeout
			fase = 4
			hacer_fase()
		4:
			var nivel = get_tree().root.get_node("Nivel")
			if nivel.has_node("AnimationPlayer"):
				nivel.get_node("AnimationPlayer").play("fase_final")
			await get_tree().create_timer(1.5).timeout
			show()
			vida = 10000
			print("Fase Final")
			detenido = false
			if not atacando:
				$AnimatedSprite2D.play("Moverse")

			if not has_node("TimerAtaqueFinal"):
				timer_ataque_final = Timer.new()
				timer_ataque_final.name = "TimerAtaqueFinal"
				timer_ataque_final.wait_time = 20
				timer_ataque_final.autostart = true
				timer_ataque_final.one_shot = false
				timer_ataque_final.connect("timeout", Callable(self, "_on_timer_fase_final_timeout"))
				add_child(timer_ataque_final)
func _on_timer_fase_1_timeout():
	var focas = [
		foca_escena_chaleco,
		foca_escena_chaleco_casco,
		foca_escena_blindada,
		foca_escena_payaso
	]

	var foca_escena = focas[randi() % focas.size()]
	var nivel = get_tree().root.get_node("Nivel")

	if foca_escena == foca_escena_payaso:
		$SonidoPayaso.play()
		for i in range(1, 6):
			var carril = nivel.get_node(str(i))
			if carril:
				var nueva_foca = foca_escena.instantiate()
				carril.add_child(nueva_foca)
				nueva_foca.rotation_degrees = 90
				nueva_foca.progress_ratio = 0
	else:
		var carril = nivel.get_node(str(1 + randi() % 5))
		if carril:
			var nueva_foca = foca_escena.instantiate()
			carril.add_child(nueva_foca)
			nueva_foca.rotation_degrees = 90
			nueva_foca.progress_ratio = 0

func _on_timer_fase_2_timeout():
	var nivel = get_tree().root.get_node("Nivel")
	for i in range(1, 6):
		var carril = nivel.get_node(str(i))
		if carril:
			var nueva_foca = foca_escena_hielo.instantiate()
			carril.add_child(nueva_foca)
			nueva_foca.rotation_degrees = 90
			nueva_foca.progress_ratio = 0

func _on_timer_fase_3_timeout():
	var nivel = get_tree().root.get_node("Nivel")
	for i in range(1, 6):
		var carril = nivel.get_node(str(i))
		if carril:
			var nueva_foca = foca_escena_ignea.instantiate()
			carril.add_child(nueva_foca)
			nueva_foca.rotation_degrees = 90
			nueva_foca.progress_ratio = 0

func _on_timer_fase_final_timeout():
	summonear_ataque_random()

func summonear_ataque_random():
	var nivel = get_tree().root.get_node("Nivel")
	# ❌ Eliminar proyectiles existentes en todos los carriles
	for i in range(1, 6):
		var carril = nivel.get_node(str(i))
		if carril:
			for hijo in carril.get_children():
				if hijo.name == "ProyectilFuego" or hijo.name == "ProyectilHielo":
					hijo.queue_free()

	# ✅ Elegir ataque y línea
	var tipo = ["fuego", "hielo"].pick_random()
	var linea = 1 + randi() % 5
	print("⚠️ Ataque de %s en la línea %d" % [tipo, linea])

	if tipo == "fuego":
		invocar_ataque_fuego(linea)
	else:
		invocar_ataque_hielo(linea)

func invocar_ataque_fuego(linea):
	var nivel = get_tree().root.get_node("Nivel")
	var carril = nivel.get_node(str(linea))
	if carril:
		var proyectil = proyectil_fuego_boss.instantiate()
		proyectil.name = "ProyectilFuego"
		carril.add_child(proyectil)
		proyectil.rotation_degrees = 90
		proyectil.progress_ratio = 0

func invocar_ataque_hielo(linea):
	var nivel = get_tree().root.get_node("Nivel")
	var carril = nivel.get_node(str(linea))
	if carril:
		var proyectil = proyectil_hielo_boss.instantiate()
		proyectil.name = "ProyectilHielo"
		carril.add_child(proyectil)
		proyectil.rotation_degrees = 90
		proyectil.progress_ratio = 0
