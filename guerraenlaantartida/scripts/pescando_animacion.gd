extends Node2D

var pesca_timer: Timer
var reset_timer: Timer
@onready var boton_pescar = $BotonPescar
@onready var pescando_animacion = $PescandoAnimacion  # Asegúrate de que esto sea un nodo AnimationPlayer

func _ready() -> void:
	# Cambiar la animación y reproducirla
	pescando_animacion.play("pescando")
	
	pesca_timer = Timer.new()
	pesca_timer.one_shot = true
	pesca_timer.wait_time = randf_range(6.0, 8.0)
	pesca_timer.connect("timeout", Callable(self, "_on_pesca_timeout"))
	add_child(pesca_timer)
	pesca_timer.start()

	reset_timer = Timer.new()
	reset_timer.one_shot = true
	reset_timer.wait_time = 6.0
	reset_timer.connect("timeout", Callable(self, "_on_reset_timeout"))
	add_child(reset_timer)

func _on_pesca_timeout() -> void:
	# Cambiar la animación y reproducirla
	pescando_animacion.play("hay_pesca")
	reset_timer.start()
	if boton_pescar:
		boton_pescar.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		print("Error: BotonPescar no encontrado")

func _on_reset_timeout() -> void:
	volver_a_pescar()
	$BotonPescar.set_default_cursor_shape(Input.CURSOR_ARROW)

func jugador_interactua() -> void:
	var es_dorado := randf() < 0.1
	if es_dorado:
		Global.pecesDorados += 1
		get_tree().root.get_node("Nivel")._actualizar_label_peces_dorados()
	else:
		Global.peces += 1
		get_tree().root.get_node("Nivel")._actualizar_label_peces()
	volver_a_pescar()

func volver_a_pescar() -> void:
	reset_timer.stop()
	pescando_animacion.play("pescando")
	pesca_timer.wait_time = randf_range(5.0, 8.0)
	pesca_timer.start()

	# Restablecer cursor a flecha aquí también
	if boton_pescar:
		boton_pescar.set_default_cursor_shape(Input.CURSOR_ARROW)

	
func _on_boton_pescar_pressed() -> void:
	if pescando_animacion.animation == "hay_pesca":
		jugador_interactua()
