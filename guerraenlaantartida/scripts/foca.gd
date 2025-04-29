extends PathFollow2D

@export var velocidad = 0.03
var atacando = false
var objetivo = null
@export var vida = 100
@export var daño = 25
@export var armadura = 0

 

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
		get_tree().root.get_node("Nivel1").terminarjuego()

	if not atacando and $AnimatedSprite2D.animation == "Moverse":
		progress_ratio += velocidad * _delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("pinguino") and not atacando:
		objetivo = area.get_parent()
		atacando = true
		$AnimatedSprite2D.play("Ataque")
		$Timer.start()
	elif area.is_in_group("proyectil"):
		var proyectil = area.get_parent()
		if proyectil.has_method("get"): 
			if "daño" in proyectil:
				vida -= proyectil.daño
				print("Daño recibido:", proyectil.daño)
				print("Vida restante:", vida)
			else:
				print("El proyectil no tiene la variable 'daño'")


func _on_area_2d_area_exited(area):
	if area.get_parent() == objetivo:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")

func _on_timer_timeout():
	if objetivo and is_instance_valid(objetivo):
		objetivo.recibir_daño(daño)
		$Timer.start()
	else:
		atacando = false
		objetivo = null
		$AnimatedSprite2D.play("Moverse")
