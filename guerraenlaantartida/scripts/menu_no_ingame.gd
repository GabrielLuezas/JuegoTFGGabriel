extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_opciones_pressed() -> void:
	var escena_opciones = preload("res://escenas/menu_opciones.tscn").instantiate()
	add_child(escena_opciones)


func _on_menu_principal_pressed() -> void:
	queue_free()
