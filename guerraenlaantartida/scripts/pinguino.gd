extends Node2D

var vida = 10
var proyectil = preload("res://escenas/proyectil.tscn")
var atacando = false 

func _ready():
	add_to_group("pinguino")  # Asegúrate de que solo los reales estén en este grupo

func _process(delta: float) -> void:
	if vida <= 0:
		queue_free()
	det_enemigo()

func recibir_daño(cantidad: int):
	vida -= cantidad
	print("Me han hecho daño, vida restante: " + str(vida))

func ataque():
	var ataque = proyectil.instantiate()
	$Marker2D.add_child(ataque)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "atacar":
		ataque()
		atacando = false  # Permitir nuevo ataque si sigue el enemigo

func det_enemigo():
	var espacio = get_world_2d().direct_space_state
	var origen = $RayCast2D.global_position
	var destino = origen + $RayCast2D.target_position.rotated($RayCast2D.global_rotation)

	var excluir := [self]
	var colision_valida = null

	# Buscar hasta 5 objetos distintos a lo largo del rayo
	for i in range(5):
		var parametros = PhysicsRayQueryParameters2D.create(origen, destino)
		parametros.exclude = excluir
		parametros.collide_with_areas = true
		parametros.collide_with_bodies = true

		var resultado = espacio.intersect_ray(parametros)
		if not resultado:
			break

		var colision = resultado.collider
		excluir.append(colision)  # Evitar detectar lo mismo en el siguiente intento

		# Si no es ignorado, lo consideramos válido
		if not colision.is_in_group("proyectiles") and not colision.is_in_group("ignorar_raycast"):
			colision_valida = colision
			break

	if colision_valida:
		if not atacando:
			atacando = true
			$AnimatedSprite2D.play("atacar")
	else:
		if not atacando:
			$AnimatedSprite2D.play("default")
