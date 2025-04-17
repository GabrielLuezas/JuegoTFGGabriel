extends Node2D

var velocidad = 75

var daño = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += velocidad * delta
	


func _on_area_2d_area_entered(area):
	if area.is_in_group("focas"):
		$".".queue_free()
