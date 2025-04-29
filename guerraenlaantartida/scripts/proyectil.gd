extends Node2D

@export var velocidad = 75
@export var daño = 10

func _ready():
	z_index = 1

func _process(delta):
	position.x += velocidad * delta
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("focas"):
		$".".queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()
