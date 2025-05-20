extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_reiniciar_nivel_pressed() -> void:
	Engine.time_scale = 1.0
	var current_scene = get_tree().current_scene
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene.scene_file_path)


func _on_opciones_pressed() -> void:
	var escena_opciones = preload("res://escenas/menu_opciones.tscn").instantiate()
	add_child(escena_opciones)


func _on_menu_principal_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")


func _on_volver_al_nivel_pressed() -> void:
	get_parent().toggle_pause()
