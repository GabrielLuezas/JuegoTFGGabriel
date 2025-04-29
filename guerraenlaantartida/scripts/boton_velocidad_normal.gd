extends TextureButton


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Engine.time_scale = 1.0
	print("Velocidad normal")
