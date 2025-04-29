extends TextureButton

var texture_play := preload("res://img/botonplay.png")
var texture_pause := preload("res://img/botonpausa.png")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_icon()


func update_icon():
	if get_tree().paused:
		texture_normal = texture_play
	else:
		texture_normal = texture_pause


func _on_pressed() -> void:
	get_tree().paused = !get_tree().paused
	update_icon()
