extends Node2D

@export var velocidad = 75
@export var daño = 5
@export var tiempo_division = 1.0  
@export var escala_reducida = 0.5  
@export var es_de_fuego := false

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

	var desplazamiento_y = 75  # Distancia vertical entre los proyectiles secundarios

	for index in range(3):  # Tres proyectiles
		var offset_y := 0.0
		if index == 0:
			offset_y = -desplazamiento_y
		elif index == 2:
			offset_y = desplazamiento_y

		var nueva_y := global_position.y + offset_y
		if nueva_y < 70 or nueva_y > 458:
			continue  # No generar este proyectil

		var nuevo_proyectil = escena_proyectil.instantiate()
		get_parent().add_child(nuevo_proyectil)

		nuevo_proyectil.global_position = global_position
		nuevo_proyectil.global_position.y = nueva_y
		nuevo_proyectil.scale = scale * escala_reducida
		
		nuevo_proyectil.es_de_fuego = es_de_fuego
		
		# 👉 Asegurar que el daño se copie
		nuevo_proyectil.daño = daño

		# Rotación de dispersión 
		var angulo = -30 + (index * 30)
		nuevo_proyectil.rotation = rotation + deg_to_rad(angulo)


func _on_area_2d_area_entered(area):
	if area.is_in_group("focas"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
