extends TextureButton


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Engine.time_scale = 3.0
	print("Velocidad x3")
