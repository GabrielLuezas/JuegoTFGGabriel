extends Node2D

@export var velocidad = 75
@export var daño = 10
@export var ignoraArmadura = false
@export var enemigosAtravesados = 0
@export var maxEnemigosAtravesados = 2
var enemigos_tocados = []  

func _ready() -> void:
	# Poner el proyectil por encima de la foca
	z_index = 1  # Valor más alto que el predeterminado para asegurarse de que esté encima

func _process(delta):
	position.x += velocidad * delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("focas"):
		if area not in enemigos_tocados:
			enemigosAtravesados += 1
			enemigos_tocados.append(area)

			# Si el máximo de enemigos atravesados es 3, aumenta el daño con cada enemigo
			if maxEnemigosAtravesados == 3:
				daño += 1  # Aumenta el daño por cada enemigo atravesado
			if maxEnemigosAtravesados == 4:
				daño += 2

			if enemigosAtravesados >= maxEnemigosAtravesados:
				$".".queue_free()  # El proyectil se destruye

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()
