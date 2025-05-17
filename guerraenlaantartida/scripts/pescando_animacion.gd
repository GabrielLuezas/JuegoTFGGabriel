extends Node2D

# Rango de tiempo modificable para la aparición de peces
@export var min_tiempo_espera: float = 6.0
@export var max_tiempo_espera: float = 8.0
@export var probabilidad_pez_dorado: float = 0.1  # ← Probabilidad entre 0.0 y 1.0

var pesca_timer: Timer
var reset_timer: Timer

@onready var boton_pescar = $BotonPescar
@onready var pescando_animacion = $PescandoAnimacion

func _ready() -> void:
	pescando_animacion.play("pescando")

	pesca_timer = Timer.new()
	pesca_timer.one_shot = true
	pesca_timer.wait_time = randf_range(min_tiempo_espera, max_tiempo_espera)
	pesca_timer.timeout.connect(_on_pesca_timeout)
	add_child(pesca_timer)
	pesca_timer.start()

	reset_timer = Timer.new()
	reset_timer.one_shot = true
	reset_timer.wait_time = 6.0
	reset_timer.timeout.connect(_on_reset_timeout)
	add_child(reset_timer)

func _on_pesca_timeout() -> void:
	pescando_animacion.play("hay_pesca")
	reset_timer.start()
	if boton_pescar:
		boton_pescar.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_reset_timeout() -> void:
	volver_a_pescar()
	boton_pescar.set_default_cursor_shape(Input.CURSOR_ARROW)

func jugador_interactua() -> void:
	boton_pescar.disabled = true

	var es_dorado := randf() < probabilidad_pez_dorado

	if Global.nivelMaximoConseguido < 2:
		es_dorado = false

	if es_dorado:
		Global.pecesDorados += 1
		if get_parent().has_method("reproducir_animacion_para_dorado"):
			get_parent().reproducir_animacion_para_dorado(name)
		await get_tree().create_timer(1.0).timeout
		get_tree().root.get_node("Nivel")._actualizar_label_peces_dorados()
	else:
		var cantidad := randi_range(1, 3)
		Global.peces += cantidad
		if get_parent().has_method("reproducir_animacion_para"):
			get_parent().reproducir_animacion_para(name)
		await get_tree().create_timer(1.0).timeout
		get_tree().root.get_node("Nivel")._actualizar_label_peces()

	volver_a_pescar()
	boton_pescar.disabled = false

func volver_a_pescar() -> void:
	reset_timer.stop()
	pescando_animacion.play("pescando")
	pesca_timer.wait_time = randf_range(min_tiempo_espera, max_tiempo_espera)
	pesca_timer.start()

	if boton_pescar:
		boton_pescar.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_boton_pescar_pressed() -> void:
	if pescando_animacion.animation == "hay_pesca":
		jugador_interactua()
