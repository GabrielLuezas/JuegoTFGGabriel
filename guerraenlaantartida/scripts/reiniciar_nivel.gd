extends Button

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Engine.time_scale = 1.0
	var current_scene = get_tree().current_scene
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene.scene_file_path)
