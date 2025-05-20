extends Control  # O Control, si estás en un menú

var ruta = "res://escenas/nivel.tscn"

func _ready():
	pass
func _process(delta):
	pass



func _on_repetir_nivel_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_campamento_principal_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")
