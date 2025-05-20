extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Textos/MejoraSeleccionada.hide()
	$Textos/Nivel1.hide()
	$Textos/Nivel2.hide()
	$Textos/Nivel3.hide()
	$Textos/Nivel4.hide()
	$Mejora1.hide()
	$Mejora2.hide()
	$Mejora3.hide()
	$Mejora4.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boton_mejora_1_pressed() -> void:
	$Textos/MejoraSeleccionada.show()
	$Mejora1.show()
	$Mejora2.hide()
	$Mejora4.hide()
	$Mejora3.hide()
	$Textos/Nivel1.show()
	$Textos/Nivel2.show()
	$Textos/Nivel3.show()
	$Textos/Nivel4.show()
	$Textos/MejoraSeleccionada.text = "DISPARO MÚLTIPLE"
	$Textos/Nivel1.text = "Nivel 1\nDispara 2 bolas en vez de 1"
	$Textos/Nivel2.text = "Nivel 2\nEl daño aumenta de 10 a 12"
	$Textos/Nivel3.text = "Nivel 3\nDispara 3 bolas y el daño aumenta de 12 a 14"
	$Textos/Nivel4.text = "Nivel 4\nEl daño aumenta de 14 a 18"


func _on_boton_mejora_2_pressed() -> void:
	$Textos/MejoraSeleccionada.show()
	$Mejora2.show()
	$Mejora1.hide()
	$Mejora3.hide()
	$Mejora4.hide()
	$Textos/Nivel1.show()
	$Textos/Nivel2.show()
	$Textos/Nivel3.show()
	$Textos/Nivel4.show()
	$Textos/MejoraSeleccionada.text = "FLECHA DE HIELO"
	$Textos/Nivel1.text = "Nivel 1\nLa flecha atraviesa a un enemigo y es más rápida"
	$Textos/Nivel2.text = "Nivel 2\nEl daño aumenta de 10 a 15"
	$Textos/Nivel3.text = "Nivel 3\nLa flecha atraviesa hasta 3 enemigos"
	$Textos/Nivel4.text = "Nivel 4\nAumenta 2 de daño por enemigo atravesado"



func _on_boton_mejora_3_pressed() -> void:
	$Textos/MejoraSeleccionada.show()
	$Mejora1.hide()
	$Mejora2.hide()
	$Mejora4.hide()
	$Mejora3.show()
	$Textos/Nivel1.show()
	$Textos/Nivel2.show()
	$Textos/Nivel3.show()
	$Textos/Nivel4.show()
	$Textos/MejoraSeleccionada.text = "DISPERSIÓN DE NIEVE"
	$Textos/Nivel1.text = "Nivel 1\nLa bola se dispersa a las líneas adyacentes"
	$Textos/Nivel2.text = "Nivel 2\nMás velocidad de disparo y bolas de fuego"
	$Textos/Nivel3.text = "Nivel 3\nMás velocidad de disparo"
	$Textos/Nivel4.text = "Nivel 4\nLas bolas se vuelven a dispersar"



func _on_boton_mejora_4_pressed() -> void:
	$Textos/MejoraSeleccionada.show()
	$Mejora1.hide()
	$Mejora2.hide()
	$Mejora3.hide()
	$Mejora4.show()
	$Textos/Nivel1.show()
	$Textos/Nivel2.show()
	$Textos/Nivel3.show()
	$Textos/Nivel4.show()
	$Textos/MejoraSeleccionada.text = "RÁFAGA DE NIEVE"
	$Textos/Nivel1.text = "Nivel 1\nSe lanza una ráfaga de 6 bolas que congelan"
	$Textos/Nivel2.text = "Nivel 2\nSe reduce el tiempo entre ráfaga y ráfaga"
	$Textos/Nivel3.text = "Nivel 3\nSe reduce aún más el tiempo entre ráfagas"
	$Textos/Nivel4.text = "Nivel 4\nLos enemigos se congelan durante 2 segundos más"


func _on_boton_salir_pressed() -> void:
	var nodo_nivel = get_tree().get_root().get_node("Nivel")
	if nodo_nivel:
		nodo_nivel.pausa = false
		nodo_nivel.toggle_pausa_menu_libro()
	hide()
