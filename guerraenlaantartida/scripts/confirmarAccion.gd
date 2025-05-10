extends Control

signal resultado(decision: bool)

func _on_aceptar_pressed():
	emit_signal("resultado", true)
	queue_free() 

func _on_rechazar_pressed():
	emit_signal("resultado", false)
	queue_free()
