extends Sprite2D


func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://escenas/menu_principal.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
