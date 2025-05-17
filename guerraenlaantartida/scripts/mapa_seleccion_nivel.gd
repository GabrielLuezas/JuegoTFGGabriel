extends Control

var nivel
func _ready():
	$Textos/NivelActual.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Textos/Enemigos.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Textos/Jugar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cambiarMapa()
	if Global.nivelMaximoConseguido == 0:
		_on_boton_campamento_pressed()
	else:
		call("_on_boton_nivel_%d_pressed" % Global.nivelMaximoConseguido)
	
func _process(delta: float):
	pass

func _on_boton_nivel_1_pressed():
	$Imagenes/ImagenFoca1.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca2.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca3.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca4.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca5.texture = load("res://img/Focas/FocaNormal/102.png")
	seleccionar_nivel(1)

func _on_boton_nivel_2_pressed():
	$Imagenes/ImagenFoca1.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca2.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca3.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca4.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca5.texture = load("res://img/Focas/FocaNormalChaleco/113.png")
	seleccionar_nivel(2)

func _on_boton_nivel_3_pressed():
	$Imagenes/ImagenFoca1.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca2.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca3.texture = load("res://img/Focas/FocaNormal/102.png")
	$Imagenes/ImagenFoca4.texture = load("res://img/Focas/FocaNormalChaleco/113.png")
	$Imagenes/ImagenFoca5.texture = load("res://img/Focas/FocaNormalChalecoCasco/123.png")
	seleccionar_nivel(3)

func _on_boton_nivel_4_pressed():
	seleccionar_nivel(4)

func _on_boton_nivel_5_pressed():
	seleccionar_nivel(5)

func _on_boton_nivel_6_pressed():
	seleccionar_nivel(6)

func _on_boton_nivel_7_pressed():
	seleccionar_nivel(7)

func _on_boton_nivel_8_pressed():
	seleccionar_nivel(8)

func _on_boton_nivel_9_pressed():
	seleccionar_nivel(9)

func _on_boton_nivel_10_pressed():
	seleccionar_nivel(10)

func _on_boton_nivel_11_pressed():
	seleccionar_nivel(11)


func _on_boton_nivel_12_pressed():
	seleccionar_nivel(12)

func seleccionar_nivel(nivel: int) -> void:
	Global.nivelActual = nivel
	$Textos/NivelActual.text = "NIVEL %d" % nivel
	$Textos/Jugar.text = "JUGAR"
	$ContenidoLibro/DebajoDeTexto2.show()
	$ContenidoLibro/CirculosSpritesFocasDelNivel.show()
	$Imagenes.show()
	$Imagenes/ImagenFoca1.show()
	$Imagenes/ImagenFoca2.show()
	$Imagenes/ImagenFoca3.show()
	$Imagenes/ImagenFoca4.show()
	$Imagenes/ImagenFoca5.show()
	$Textos/Enemigos.show()

func _on_boton_jugar_pressed():
	var texto = $Textos/Jugar.text
	if texto == "JUGAR":
		get_tree().change_scene_to_file("res://escenas/nivel.tscn")
	else:
		get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")


func cambiarMapa():
	var ruta_mapa = "res://img/Mapas/"
	if Global.nivelMaximoConseguido == 0:
		ruta_mapa += "MapaBase.png"
	else:
		ruta_mapa += "MapaNivel%dPasado.png" % Global.nivelMaximoConseguido
	$Imagenes/ImagenMapa.texture = load(ruta_mapa)

	# Mostrar botones de nivel disponibles
	for i in range(1, 13):  # Del 1 al 12
		var boton = $Botones.get_node("BotonNivel" + str(i))
		if is_instance_valid(boton):
			if i <= Global.nivelMaximoConseguido + 1:
				boton.show()
				boton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			else:
				boton.hide()
				boton.mouse_default_cursor_shape = Control.CURSOR_ARROW  


func _on_boton_campamento_pressed() -> void:
	$Textos/Jugar.text = "VOLVER"
	$Textos/NivelActual.text = "CAMPAMENTO"
	$ContenidoLibro/DebajoDeTexto2.hide()
	$ContenidoLibro/CirculosSpritesFocasDelNivel.hide()
	$Imagenes/ImagenFoca1.hide()
	$Imagenes/ImagenFoca2.hide()
	$Imagenes/ImagenFoca3.hide()
	$Imagenes/ImagenFoca4.hide()
	$Imagenes/ImagenFoca5.hide()
	$Textos/Enemigos.hide()
