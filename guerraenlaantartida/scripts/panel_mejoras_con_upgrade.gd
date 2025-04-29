extends Control

var vida: int = 1
var daño: int = 1
var pinguino_actual = null


func _ready() -> void:
	$NombrePinguino.bbcode_enabled = true
	$NombrePinguino.bbcode_text = "[center]Pingüino Real[/center]"
	
	$CantidadVidaPinguino.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$"CantidadDañoPinguino".horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	if Global.pecesDorados >= 1 :
		$CapaBotonMejoraPuede.show()
		$CapaBotonMejoraPuedeIcono.show()
		$CapaBotonMejoraNoPuede.hide()
		$CapaBotonMejoraNoPuedeIcono.hide()
	else:
		$CapaBotonMejoraPuede.hide()
		$CapaBotonMejoraPuedeIcono.hide()
		$CapaBotonMejoraNoPuede.show()
		$CapaBotonMejoraNoPuedeIcono.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boton_cerrar_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$".".queue_free()


func _on_boton_libro_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.


func _on_boton_vender_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if pinguino_actual:
			pinguino_actual.queue_free()
			Global.peces = Global.peces + 3
			var nivel1 = get_tree().root.get_node("Nivel1")
			nivel1._actualizar_label_peces()
			nivel1._actualizar_label_peces_dorados()
			$".".queue_free()

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


func customizarPanel():
	if pinguino_actual.mejora == "Disparo Multiple":
		$PanelDeMejora2.show()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.hide()
	elif pinguino_actual.mejora == "Bola Gigante":
		$PanelDeMejora2.hide()
		$PanelDeMejora2.show()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.hide()
	elif pinguino_actual.mejora == "Dispersion de Nieve":
		$PanelDeMejora2.hide()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.show()
		$PanelDeMejora4.hide()
	else:
		$PanelDeMejora2.hide()
		$PanelDeMejora2.hide()
		$PanelDeMejora3.hide()
		$PanelDeMejora4.show()
		
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


func _on_boton_mejorar_nivel_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.pecesDorados >= 1 and pinguino_actual.nivelMejora < 4:
		if pinguino_actual:
			pinguino_actual.nivelMejora = pinguino_actual.nivelMejora + 1
			if pinguino_actual.mejora == "Disparo Multiple":
				mejorarDisparoMultiple()
			elif pinguino_actual.mejora == "Flecha Hielo":
				mejorarFlechaHielo()
			
			Global.pecesDorados = Global.pecesDorados - 1
			var nivel1 = get_tree().root.get_node("Nivel1")
			nivel1._actualizar_label_peces_dorados()
			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()
			if pinguino_actual.nivelMejora < 4 :
				$CapaBotonMejoraPuede.show()
				$CapaBotonMejoraPuedeIcono.show()
				$CapaBotonMejoraNoPuede.hide()
				$CapaBotonMejoraNoPuedeIcono.hide()
			else:
				$CapaBotonMejoraPuede.hide()
				$CapaBotonMejoraPuedeIcono.hide()
				$CapaBotonMejoraNoPuede.show()
				$CapaBotonMejoraNoPuedeIcono.show()

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
