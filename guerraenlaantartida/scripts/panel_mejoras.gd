extends Control

var vida: int = 1
var daño: int = 1
var pinguino_actual = null
@onready var libro_mejoras_escena = preload("res://escenas/libro_mejoras.tscn")

func _ready():
		
	if Global.pecesDorados >= 1:
		$SuperiorASuperiorASuperior.show()
		$SuperiorASuperiorSinMover.show()
		$SuperiorASuperiorASuperiorNoPeces.hide()
		$SuperiorASuperiorSinMoverNoPeces.hide()
		$Mejora1/BotonMejora1.show()
		$Mejora2/BotonMejora2.show()
		$Mejora3/BotonMejora3.show()
		$Mejora4/BotonMejora4.show()
	else:
		$SuperiorASuperiorASuperior.hide()
		$SuperiorASuperiorSinMover.hide()
		$SuperiorASuperiorASuperiorNoPeces.show()
		$SuperiorASuperiorSinMoverNoPeces.show()
		$Mejora1/BotonMejora1.hide()
		$Mejora2/BotonMejora2.hide()
		$Mejora3/BotonMejora3.hide()
		$Mejora4/BotonMejora4.hide()

	$CantidadVidaPinguino.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$"CantidadDañoPinguino".horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	


func _process(delta: float) -> void:
	pass

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
	
func _on_boton_cerrar_pressed() -> void:
	$".".queue_free()
	pinguino_actual.get_node("AuraAmarilla").hide()

func _on_boton_libro_pressed() -> void:
	var nodo_nivel = get_tree().get_root().get_node("Nivel")
	var libro = nodo_nivel.get_node("LibroMejoras")
	
	libro.show()
	
	while nodo_nivel and nodo_nivel.name != "Nivel":
		nodo_nivel = nodo_nivel.get_parent()

	if nodo_nivel:
		nodo_nivel.pausa = true
		nodo_nivel.toggle_pausa_menu_libro()
	else:
		push_error("No se encontró el nodo 'Nivel' en la jerarquía.")


func _on_boton_vender_pressed() -> void:
	if pinguino_actual:
			Global.pinguino_seleccionado_aura_amarilla = null
			pinguino_actual.queue_free()
			Global.peces = Global.peces + 3
			var nivel1 = get_tree().root.get_node("Nivel")
			nivel1._actualizar_label_peces()
			nivel1._actualizar_label_peces_dorados()
			$".".queue_free()


func _on_boton_mejora_1_pressed() -> void:
	if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Disparo Multiple"
			
			pinguino_actual.proyectil = preload("res://escenas/disparo_multiple.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()


func _on_boton_mejora_2_pressed() -> void:
	if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Flecha Hielo"
			
			pinguino_actual.proyectil = preload("res://escenas/flechahielo.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()


func _on_boton_mejora_3_pressed() -> void:
	if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Dispersion de Nieve"
			
			pinguino_actual.set_cadencia_disparo(0.85)
			
			pinguino_actual.proyectil = preload("res://escenas/dispersion_de_nieve.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()


func _on_boton_mejora_4_pressed() -> void:
	if pinguino_actual:
			pinguino_actual.nivelMejora = 1
			pinguino_actual.mejora = "Rafaga de Nieve"
			
			pinguino_actual.set_cadencia_disparo(0.1)
			pinguino_actual.proyectil = preload("res://escenas/rafaga_de_nieve.tscn")
			
			Global.pecesDorados = Global.pecesDorados -1
			var nivel = get_tree().get_nodes_in_group("nivel")[0]
			nivel._reset()
			nivel._actualizar_label_peces_dorados()
			
			var panel = get_tree().root.get_node("Nivel/SitioMejorasPinguinos").get_node_or_null("panel_mejoras")
			if panel:
				panel.queue_free()
				await panel.tree_exited

			var boton = pinguino_actual.get_node("BotonPinguino")
			if boton:
				boton._on_pressed()
