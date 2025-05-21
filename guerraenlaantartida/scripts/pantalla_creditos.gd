
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$Label.show()
	await get_tree().create_timer(5.0).timeout
	$Label2.show()
	await get_tree().create_timer(5.0).timeout
	$Label3.show()
	await get_tree().create_timer(5.0).timeout
	$Label4.show()
	await get_tree().create_timer(5.0).timeout
	$Label5.show()
	await get_tree().create_timer(5.0).timeout
	$AudioStreamPlayer2D.stop()
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
