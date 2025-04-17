extends Node2D

var pinguino_preview = preload("res://escenas/pinguino_preview.tscn")
var conteo = 0

func _ready():
	_actualizar_label_peces()
	add_to_group("nivel") # Para poder acceder desde otras escenas

func _process(delta: float) -> void:
	if $Pinguinos.get_child_count() > 0:
		$Pinguinos.get_child(0).global_position = get_global_mouse_position()

	conteo = $Pinguinos.get_child_count()

func _on_button_pressed() -> void:
	if conteo == 0 and Global.peces >= 5:
		Global.modo_compra = true
		var preview = pinguino_preview.instantiate()
		$Pinguinos.add_child(preview)
		_actualizar_label_peces()
	elif Global.peces < 5:
		print("No tienes suficientes peces para comprar un pingüino.")

func _reset():
	if $Pinguinos.get_child_count() > 0:
		$Pinguinos.get_child(0).queue_free()

# 🔄 Esta función actualiza el Label con los peces actuales
func _actualizar_label_peces():
	$ConteoPeces.text = str(Global.peces)
