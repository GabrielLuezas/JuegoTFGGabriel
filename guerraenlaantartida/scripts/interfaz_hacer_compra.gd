extends Control

signal resultado(decision: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TuDinero2.text = str(Global.dineroAcumulado)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_aceptar_pressed():
	emit_signal("resultado", true)
	queue_free() 

func _on_rechazar_pressed():
	emit_signal("resultado", false)
	queue_free()
