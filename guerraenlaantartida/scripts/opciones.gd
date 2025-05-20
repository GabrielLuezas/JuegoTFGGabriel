extends Button


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var escena_opciones = preload("res://escenas/menu_opciones.tscn").instantiate()
	add_child(escena_opciones)
	
