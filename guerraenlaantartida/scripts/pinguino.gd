class_name Pinguino
extends Node2D

@export var cadencia_disparo: float = 1.0
@export var vida: int = 100
@export var proyectil = preload("res://escenas/proyectil.tscn")
@export var nivelMejora: int = 0
@export var mejora: String = ""
@export var afecta_voladores: bool

var focas_en_rango: Array = []
var disparo_timer: Timer

# 🔥 Quemadura
var quemado = false
var tiempo_quemado = 3
var daño_por_quemadura = 5
var timer_quemadura: Timer

# ❄️ Congelación
var congelado = false
var timer_congelado: Timer
var tiempo_congelacion = 3.0

func _ready():
	add_to_group("pinguino")
	$BotonPinguino.modulate.a = 0.0

	# Timer de disparo
	disparo_timer = Timer.new()
	disparo_timer.name = "DisparoTimer"
	disparo_timer.wait_time = 1.0 / cadencia_disparo
	disparo_timer.one_shot = false
	disparo_timer.autostart = true
	add_child(disparo_timer)
	disparo_timer.connect("timeout", Callable(self, "_on_disparo_timer_timeout"))

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

	# Conectar colisión con otras áreas (fuego/hielo)
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))

	$AnimatedSprite2D.speed_scale = cadencia_disparo

func set_cadencia_disparo(nueva: float) -> void:
	cadencia_disparo = nueva
	if disparo_timer:
		disparo_timer.wait_time = 1.0 / cadencia_disparo
	$AnimatedSprite2D.speed_scale = cadencia_disparo

func _process(_delta: float) -> void:
	if vida <= 0:
		queue_free()

func recibir_daño(cantidad: int):
	vida -= cantidad
	var panel
	if nivelMejora >= 1:
		panel = get_tree().root.get_node_or_null("Nivel/SitioMejorasPinguinos/panel_mejoras_con_upgrade")
	else:
		panel = get_tree().root.get_node_or_null("Nivel/SitioMejorasPinguinos/panel_mejoras")

	if panel and panel.pinguino_actual == self:
		panel.set_datos(vida, get_daño())

func ataque():
	var nuevo_proyectil = proyectil.instantiate()
	$Marker2D.add_child(nuevo_proyectil)
	$AnimatedSprite2D.play("atacar")

func _on_disparo_timer_timeout():
	if congelado:
		return  # ❄️ No disparar si está congelado
	if focas_en_rango.size() > 0:
		ataque()

func _on_detecto_enemigos_area_entered(area: Area2D) -> void:
	if area.is_in_group("focas"):
		focas_en_rango.append(area)

func _on_detecto_enemigos_area_exited(area: Area2D) -> void:
	if area.is_in_group("focas"):
		focas_en_rango.erase(area)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "atacar":
		$AnimatedSprite2D.play("default")

func get_daño() -> int:
	var instancia = proyectil.instantiate()
	if instancia.has_node("Proyectil1"):
		var proyectil1 = instancia.get_node("Proyectil1")
		return proyectil1.daño
	else:
		return instancia.daño

# 🔥 Aplicar quemadura
func aplicar_quemadura():
	if not quemado:
		quemado = true
		tiempo_quemado = 3
		timer_quemadura.start()
	else:
		tiempo_quemado = 3

func _on_timer_quemadura_timeout():
	if tiempo_quemado > 0:
		vida -= daño_por_quemadura
		tiempo_quemado -= 1
	else:
		quemado = false
		timer_quemadura.stop()

# ❄️ Aplicar congelación con duración personalizable y animación
func aplicar_congelado(tiempo: float = 3.0):
	congelado = true
	timer_congelado.stop()
	timer_congelado.wait_time = tiempo
	timer_congelado.start()
	$AnimatedSprite2D.play("Congelado")

func _on_timer_congelado_timeout():
	congelado = false
	$AnimatedSprite2D.play("default")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bolafuegoboss"):
		recibir_daño(75)
	elif area.is_in_group("bolahieloboss"):
		aplicar_congelado(10.0)
