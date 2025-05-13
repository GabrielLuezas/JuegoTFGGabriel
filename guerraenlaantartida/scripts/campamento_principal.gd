extends Control

var ruta = "res://escenas/interior_casa_normal.tscn"

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_boton_tienda_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/tienda_escena.tscn")


func _on_boton_casa_jefe_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/interior_casa_jefe.tscn")


func _on_boton_casa_1_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_2_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_3_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_4_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_1_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_2_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_3_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_4_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)
