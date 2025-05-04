extends Control

var vida: int = 1
var daño: int = 1
var pinguino_actual = null

func _ready():
	
	if Global.pecesDorados >= 1:
		$SuperiorASuperiorASuperior.show()
		$SuperiorASuperiorSinMover.show()
		$SuperiorASuperiorASuperiorNoPeces.hide()
		$SuperiorASuperiorSinMoverNoPeces.hide()
	else:
		$SuperiorASuperiorASuperior.hide()
		$SuperiorASuperiorSinMover.hide()
		$SuperiorASuperiorASuperiorNoPeces.show()
		$SuperiorASuperiorSinMoverNoPeces.show()

	$NombrePinguino.bbcode_enabled = true
	$NombrePinguino.bbcode_text = "[center]Pingüino Real[/center]"
	
	$CantidadVidaPinguino.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$"CantidadDañoPinguino".horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

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
	
	
func _on_boton_mejora_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.pecesDorados >= 1:
		if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Rafaga de Nieve"
			
			pinguino_actual.set_cadencia_disparo(0.1)
			pinguino_actual.proyectil = preload("res://escenas/rafaga_de_nieve.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel1/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()

func _on_boton_mejora_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.pecesDorados >= 1:
		if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Dispersion de Nieve"
			
			pinguino_actual.set_cadencia_disparo(0.85)
			
			pinguino_actual.proyectil = preload("res://escenas/dispersion_de_nieve.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel1/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()


func _on_boton_mejora_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.pecesDorados >= 1:
		if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Flecha Hielo"
			
			pinguino_actual.proyectil = preload("res://escenas/flechahielo.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel1/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()


func _on_boton_mejora_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.pecesDorados >= 1:
		if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Disparo Multiple"
			
			pinguino_actual.proyectil = preload("res://escenas/disparo_multiple.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel1/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()
