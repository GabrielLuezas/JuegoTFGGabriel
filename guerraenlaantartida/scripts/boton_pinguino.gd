extends TextureButton

const ESCENA_MEJORAS_NORMAL = preload("res://escenas/panel_mejoras.tscn")
const ESCENA_MEJORAS_UPGRADE = preload("res://escenas/panel_mejoras_con_upgrade.tscn")

func _on_pressed():
	if Global.nivelActual >= 1:
		var pinguino = get_parent()
		var marker = get_tree().root.get_node("Nivel/SitioMejorasPinguinos")
		
		if Global.pinguino_seleccionado_aura_amarilla and Global.pinguino_seleccionado_aura_amarilla != pinguino:
			var sombra_anterior = Global.pinguino_seleccionado_aura_amarilla.get_node("AuraAmarilla")
			if sombra_anterior:
				sombra_anterior.visible = false

		# Mostrar la sombra del pinguino actual
		var sombra_actual = pinguino.get_node("AuraAmarilla")
		if sombra_actual:
			sombra_actual.visible = true

		# Actualizar el pinguino seleccionado globalmente
		Global.pinguino_seleccionado_aura_amarilla = pinguino
	
	# Asegurarse de cerrar cualquier panel anterior SIEMPRE
		var panel_existente = marker.get_node_or_null("panel_mejoras")
		if panel_existente:
			panel_existente.queue_free()
			await panel_existente.tree_exited

		# Determinar qué escena de mejoras usar según el nivel de mejora del pingüino
		var escena_panel = ESCENA_MEJORAS_UPGRADE if pinguino.nivelMejora >= 1 else ESCENA_MEJORAS_NORMAL

		# Instanciar el nuevo panel de mejoras
		var panel = escena_panel.instantiate()
		panel.name = "panel_mejoras"
		marker.add_child(panel)
		panel.position = Vector2.ZERO
		panel.set_mouse_filter(Control.MOUSE_FILTER_STOP)

		# Enviar datos del pingüino actual al panel correctamente
		var vida = pinguino.vida
		var daño = pinguino.get_daño()
		panel.set_datos(vida, daño, pinguino)
