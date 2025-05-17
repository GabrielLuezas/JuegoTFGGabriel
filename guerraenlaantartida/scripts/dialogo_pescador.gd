extends Control

var full_text := "El jefe me ha informado de todo, así que necesitas un pescador hábil que te ayude en medio del campo de batalla, ¿verdad? Puedo ayudarte si me haces un pago de 50 monedas. Tengo una familia e hijos que alimentar."
var type_speed := 0.05
signal cerrado

func _ready() -> void:
	$BotonAceptar.hide()
	show_text_slowly_campamento(full_text)

func _process(delta: float) -> void:
	pass


func _on_boton_aceptar_pressed() -> void:
	Global.dineroAcumulado = Global.dineroAcumulado - 50
	emit_signal("cerrado")	
	queue_free() 

func show_text_slowly_campamento(text: String) -> void:
	await _reveal_text_campamento(text)
	$BotonAceptar.show()
	

func _reveal_text_campamento(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$Label.text = current
		await get_tree().create_timer(type_speed).timeout
