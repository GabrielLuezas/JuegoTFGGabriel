extends Control

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.strip_edges() != "":
		$IconoBotonGuarda.show()
		$BotonGuardar.show()
		$BotonGuardarBoton.show()
	else:
		$IconoBotonGuarda.hide()
		$BotonGuardar.hide()
		$BotonGuardarBoton.hide()


func _on_boton_guardar_boton_pressed() -> void:
	var nombre = $LineEdit.text.strip_edges()
	Global.nombreUsuario = nombre
	Global.nivelActual = 0
	Global.nivelMaximoConseguido = 0
	Global.dineroAcumulado = 0
	get_tree().change_scene_to_file("res://escenas/mapa_seleccion_nivel.tscn")
	
func _on_boton_atras_boton_pressed() -> void:
	queue_free()
