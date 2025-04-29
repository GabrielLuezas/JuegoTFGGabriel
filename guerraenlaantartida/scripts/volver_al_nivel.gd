extends Button


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var menu = get_parent().get_parent()
	menu.visible = false
	var root = menu.get_parent()
	root.pausa = false
	get_tree().paused = false
