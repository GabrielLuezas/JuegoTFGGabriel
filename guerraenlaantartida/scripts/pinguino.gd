extends Node2D

@export var cadencia_disparo: float = 1.0
@export var vida: int = 100
@export var proyectil = preload("res://escenas/proyectil.tscn")
@export var nivelMejora: int = 0
@export var mejora: String = ""
@export var afecta_voladores: bool

var focas_en_rango: Array = []
var disparo_timer: Timer  # Referencia al timer

func _ready():
	
	add_to_group("pinguino")
	$BotonPinguino.modulate.a = 0.0

	# Crear y configurar el timer
	disparo_timer = Timer.new()
	disparo_timer.name = "DisparoTimer"
	disparo_timer.wait_time = 1.0 / cadencia_disparo
	disparo_timer.one_shot = false
	disparo_timer.autostart = true
	add_child(disparo_timer)
	disparo_timer.connect("timeout", Callable(self, "_on_disparo_timer_timeout"))

	# Ajustar la velocidad de animación al ritmo de disparo
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
	if focas_en_rango.size() > 0:
		ataque()

func _on_detecto_enemigos_area_entered(area: Area2D) -> void:
	if area.is_in_group("focas"):
		focas_en_rango.append(area)
		print("Foca detectada (área): ", area.name)

func _on_detecto_enemigos_area_exited(area: Area2D) -> void:
	if area.is_in_group("focas"):
		focas_en_rango.erase(area)
		print("Foca fuera de rango (área): ", area.name)

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
