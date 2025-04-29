extends AnimatedSprite2D

var pesca_timer: Timer
var reset_timer: Timer

func _ready() -> void:
	animation = "pescando"
	play()
	
	pesca_timer = Timer.new()
	pesca_timer.one_shot = true
	pesca_timer.wait_time = randf_range(5.0, 8.0)
	pesca_timer.connect("timeout", Callable(self, "_on_pesca_timeout"))
	add_child(pesca_timer)
	pesca_timer.start()

	reset_timer = Timer.new()
	reset_timer.one_shot = true
	reset_timer.wait_time = 5.0
	reset_timer.connect("timeout", Callable(self, "_on_reset_timeout"))
	add_child(reset_timer)

	animation = "pescando"

func _on_pesca_timeout() -> void:
	animation = "hay_pesca"
	reset_timer.start()

func _on_reset_timeout() -> void:
	volver_a_pescar()

func jugador_interactua() -> void:
	var es_dorado := randf() < 0.1
	if es_dorado:
		Global.pecesDorados += 1
		get_tree().root.get_node("Nivel1")._actualizar_label_peces_dorados()
	else:
		Global.peces += 1
		get_tree().root.get_node("Nivel1")._actualizar_label_peces()
	volver_a_pescar()


func volver_a_pescar() -> void:
	reset_timer.stop()
	animation = "pescando"
	pesca_timer.wait_time = randf_range(5.0, 8.0)
	pesca_timer.start()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if animation == "hay_pesca":
			jugador_interactua()

	
