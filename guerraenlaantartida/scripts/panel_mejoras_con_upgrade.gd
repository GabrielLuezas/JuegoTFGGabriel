extends Control

var vida: int = 1
var daño: int = 1
var pinguino_actual = null


func _ready() -> void:
	$CantidadVidaPinguino.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$"CantidadDañoPinguino".horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	if Global.pecesDorados >= 1 :
		$CapaBotonMejoraPuede.show()
		$CapaBotonMejoraPuedeIcono.show()
		$CapaBotonMejoraNoPuede.hide()
		$CapaBotonMejoraNoPuedeIcono.hide()
		$BotonMejorarNivel.show()
	else:
		$CapaBotonMejoraPuede.hide()
		$CapaBotonMejoraPuedeIcono.hide()
		$CapaBotonMejoraNoPuede.show()
		$CapaBotonMejoraNoPuedeIcono.show()
		$BotonMejorarNivel.hide()
	

func _on_boton_mejorar_nivel_pressed() -> void:
	print(pinguino_actual)
	if pinguino_actual:
			pinguino_actual.nivelMejora = pinguino_actual.nivelMejora + 1
			if pinguino_actual.mejora == "Disparo Multiple":
				mejorarDisparoMultiple()
			elif pinguino_actual.mejora == "Flecha Hielo":
				mejorarFlechaHielo()
			elif pinguino_actual.mejora == "Dispersion de Nieve":
				mejorarDispersionDeNieve()
			else:
				mejoraRafaDeNieve()
			
			Global.pecesDorados = Global.pecesDorados - 1
			var nivel1 = get_tree().root.get_node("Nivel")
			nivel1._actualizar_label_peces_dorados()
			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()
			print(pinguino_actual.nivelMejora)
			if pinguino_actual.nivelMejora < 4 :
				$CapaBotonMejoraPuede.show()
				$CapaBotonMejoraPuedeIcono.show()
				$CapaBotonMejoraNoPuede.hide()
				$CapaBotonMejoraNoPuedeIcono.hide()
				$BotonMejorarNivel.show()
			else:
				$CapaBotonMejoraPuede.hide()
				$CapaBotonMejoraPuedeIcono.hide()
				$CapaBotonMejoraNoPuede.show()
				$CapaBotonMejoraNoPuedeIcono.show()
				$BotonMejorarNivel.hide()


func _on_boton_vender_pressed() -> void:
	if pinguino_actual:
			Global.pinguino_seleccionado_aura_amarilla = null
			pinguino_actual.queue_free()
			Global.peces = Global.peces + 3
			
			if pinguino_actual.nivelMejora == 1:
				Global.peces = Global.peces + 1
			elif pinguino_actual.nivelMejora == 2:
				Global.pecesDorados = Global.pecesDorados +1
			elif pinguino_actual.nivelMejora == 3:
				Global.pecesDorados = Global.pecesDorados +1
			else:
				Global.pecesDorados = Global.pecesDorados +2
			
			var nivel1 = get_tree().root.get_node("Nivel")
			nivel1._actualizar_label_peces()
			nivel1._actualizar_label_peces_dorados()
			$".".queue_free()


func _on_boton_libro_pressed() -> void:
	pass # Replace with function body.


func _on_boton_cerrar_pressed() -> void:
	$".".queue_free()
	pinguino_actual.get_node("AuraAmarilla").hide()



func set_datos(p_vida: int, p_daño: int, pinguino: Node = null) -> void:
	if p_vida == 0:
		$".".queue_free()
	else:
		vida = p_vida
		daño = p_daño
		$CantidadVidaPinguino.text = str(vida)
		$CantidadDañoPinguino.text = str(daño)
		if pinguino != null:
			pinguino_actual = pinguino
		customizarPanel()
		customizarEstrellas()
	if pinguino_actual.nivelMejora < 4 and Global.pecesDorados >= 1:
		$CapaBotonMejoraPuede.show()
		$CapaBotonMejoraPuedeIcono.show()
		$CapaBotonMejoraNoPuede.hide()
		$CapaBotonMejoraNoPuedeIcono.hide()
		$BotonMejorarNivel.show()
	else:
		$CapaBotonMejoraPuede.hide()
		$CapaBotonMejoraPuedeIcono.hide()
		$CapaBotonMejoraNoPuede.show()
		$CapaBotonMejoraNoPuedeIcono.show()
		$BotonMejorarNivel.hide()


func customizarPanel():
	if pinguino_actual.mejora == "Disparo Multiple":
		$PanelDeMejora2.show()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.hide()
		$Mejora1.show()
		$Mejora2.hide()
		$Mejora3.hide()
		$Mejora4.hide()
	elif pinguino_actual.mejora == "Flecha Hielo":
		$PanelDeMejora2.hide()
		$PanelDeMejora2.show()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.hide()
		$Mejora2.show()
		$Mejora1.hide()
		$Mejora3.hide()
		$Mejora4.hide()
	elif pinguino_actual.mejora == "Dispersion de Nieve":
		$PanelDeMejora2.hide()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.show()
		$PanelDeMejora4.hide()
		$Mejora3.show()
		$Mejora2.hide()
		$Mejora1.hide()
		$Mejora4.hide()
	else:
		$PanelDeMejora2.hide()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.show()
		$Mejora4.show()
		$Mejora2.hide()
		$Mejora1.hide()
		$Mejora3.hide()
		
func customizarEstrellas():
	if pinguino_actual.nivelMejora == 1:
		$Estrella1.show()
		$Estrella2.hide()
		$Estrella3.hide()
		$Estrella4.hide()
	elif pinguino_actual.nivelMejora == 2:
		$Estrella1.show()
		$Estrella2.show()
		$Estrella3.hide()
		$Estrella4.hide()
	elif pinguino_actual.nivelMejora == 3:
		$Estrella1.show()
		$Estrella2.show()
		$Estrella3.show()
		$Estrella4.hide()
	else:
		$Estrella1.show()
		$Estrella2.show()
		$Estrella3.show()
		$Estrella4.show()


func mejorarDisparoMultiple():
	if pinguino_actual.nivelMejora == 2:
		pinguino_actual.proyectil = preload("res://escenas/disparo_multiple_nivel_2.tscn")
	elif pinguino_actual.nivelMejora == 3:
		pinguino_actual.proyectil = preload("res://escenas/disparo_multiple_nivel_3.tscn")
	elif pinguino_actual.nivelMejora == 4:
		pinguino_actual.proyectil = preload("res://escenas/disparo_multiple_nivel_4.tscn")
		
func mejorarFlechaHielo():
	if pinguino_actual.nivelMejora == 2:
		pinguino_actual.proyectil = preload("res://escenas/flechahielo_nivel_2.tscn")
	elif pinguino_actual.nivelMejora == 3:
		pinguino_actual.proyectil = preload("res://escenas/flechahielo_nivel_3.tscn")
	elif pinguino_actual.nivelMejora == 4:
		pinguino_actual.proyectil = preload("res://escenas/flechahielo_nivel_4.tscn")

func mejorarDispersionDeNieve():
	if pinguino_actual.nivelMejora == 2:
		pinguino_actual.proyectil = preload("res://escenas/dispersion_de_nieve_nivel_2.tscn")
		pinguino_actual.set_cadencia_disparo(0.80)
	elif pinguino_actual.nivelMejora == 3:
		pinguino_actual.set_cadencia_disparo(1)
	elif pinguino_actual.nivelMejora == 4:
		pinguino_actual.proyectil = preload("res://escenas/dispersion_de_nieve_nivel_4.tscn")

func mejoraRafaDeNieve():
	if pinguino_actual.nivelMejora == 2:
		pinguino_actual.set_cadencia_disparo(0.15)
	if pinguino_actual.nivelMejora == 3:
		pinguino_actual.set_cadencia_disparo(0.2)
	if pinguino_actual.nivelMejora == 4:
		pinguino_actual.proyectil = preload("res://escenas/rafaga_de_nieve_mejorada.tscn")
