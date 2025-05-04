extends Node2D

@export var velocidad = 75
@export var daño = 7
@export var tiempo_division = 1.0  
@export var escala_reducida = 0.5  
@export var es_de_fuego := true

var tiempo_actual = 0.0  # Contador de tiempo

func _ready():
	z_index = 1

func _process(delta):
	# Incrementar el tiempo actual
	tiempo_actual += delta

	# Si el tiempo actual es menor al tiempo de división, sigue moviéndose
	if tiempo_actual < tiempo_division:
		position.x += velocidad * delta
	else:
		dividir_proyectil()
		queue_free()  # Eliminar este proyectil después de dividirse

func dividir_proyectil():
	var escena_proyectil

	if es_de_fuego:
		escena_proyectil = preload("res://escenas/proyectil_fuego.tscn")
	else:
		escena_proyectil = preload("res://escenas/proyectil.tscn")

	if not escena_proyectil or not escena_proyectil is PackedScene:
		return

	var desplazamientos_y = [-150, -70, 0, 70, 150]
	var angulos = [-60, -30, 0, 30, 60]

	for i in range(5):
		var offset_y = desplazamientos_y[i]
		var nueva_y = global_position.y + offset_y

		if nueva_y < 70 or nueva_y > 458:
			continue  # No generar este proyectil si se sale del área permitida

		var nuevo_proyectil = escena_proyectil.instantiate()
		get_parent().add_child(nuevo_proyectil)

		nuevo_proyectil.global_position = global_position
		nuevo_proyectil.global_position.y = nueva_y
		nuevo_proyectil.scale = scale * escala_reducida

		nuevo_proyectil.es_de_fuego = es_de_fuego
		nuevo_proyectil.daño = daño

		nuevo_proyectil.rotation = rotation + deg_to_rad(angulos[i])

func _on_area_2d_area_entered(area):
	if area.is_in_group("focas"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
