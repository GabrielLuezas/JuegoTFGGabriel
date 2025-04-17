extends PathFollow2D

var velocidad = 0.05
var atacando = false
var objetivo = null
var vida = 10
 

func _ready() -> void:
	rotation = 0
	$AnimatedSprite2D.play("Moverse")

func _process(_delta):
	if objetivo and not is_instance_valid(objetivo):
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")
	if vida <= 0:
		$".".queue_free()
	if progress_ratio == 1:
		$".".queue_free()

	if not atacando and $AnimatedSprite2D.animation == "Moverse":
		progress_ratio += velocidad * _delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("pinguino") and not atacando:
		objetivo = area.get_parent()
		atacando = true
		$AnimatedSprite2D.play("Ataque")
		$Timer.start()
	if area.is_in_group("proyectil"):
		vida -= 1
		print (vida)

func _on_area_2d_area_exited(area):
	if area.get_parent() == objetivo:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")

func _on_timer_timeout():
	if objetivo and is_instance_valid(objetivo):
		objetivo.recibir_daño(1)
		$Timer.start()
	else:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")
