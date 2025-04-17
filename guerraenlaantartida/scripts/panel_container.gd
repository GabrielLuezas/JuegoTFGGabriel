extends PanelContainer

var pinguinos = preload("res://escenas/pinguino.tscn")
var construccion = false
var conteo = 0

func _ready() -> void:
	self_modulate = "ffffff00"

func _process(delta: float) -> void:
	conteo = $Marker2D.get_child_count()

	if Global.modo_compra and construccion and Global.comprobacion:
		if Input.is_action_just_pressed("click"):
			if conteo == 0:
				if Global.gastar_peces(5):
					var pinguinoPut = pinguinos.instantiate()
					$Marker2D.add_child(pinguinoPut)
					construccion = false
					Global.modo_compra = false
					Global.comprobacion = false
					var nivel = get_tree().get_nodes_in_group("nivel")[0]
					nivel._reset()
					nivel._actualizar_label_peces()
				else:
					print("No tienes suficientes peces para colocar el pingüino.")

func _on_mouse_entered() -> void:
	if conteo == 0 and Global.modo_compra:
		Global.comprobacion = true
		construccion = true
		Global.ubicacion = $Marker2D.global_position

func _on_mouse_exited() -> void:
	if conteo == 0 and Global.modo_compra:
		construccion = false
		Global.comprobacion = false
		Global.ubicacion = get_global_mouse_position()
