extends TextureButton

const ESCENA_MEJORAS_NORMAL = preload("res://escenas/panel_mejoras.tscn")
const ESCENA_MEJORAS_UPGRADE = preload("res://escenas/panel_mejoras_con_upgrade.tscn")

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_pressed():
	var pinguino = get_parent()
	var marker = get_tree().root.get_node("Nivel1/SitioMejorasPinguinos")
	var panel = marker.get_node_or_null("panel_mejoras")

	var escena_panel = ESCENA_MEJORAS_UPGRADE if pinguino.nivelMejora >= 1 else ESCENA_MEJORAS_NORMAL
	var escena_path_actual = escena_panel.resource_path

	if panel and panel.scene_file_path != escena_path_actual:
		panel.queue_free()
		panel = null
		await get_tree().process_frame

	if panel:
		panel.show()
		marker.move_child(panel, marker.get_child_count() - 1)
		panel.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	else:
		panel = escena_panel.instantiate()
		panel.name = "panel_mejoras"
		marker.add_child(panel)
		panel.position = Vector2.ZERO
		panel.set_mouse_filter(Control.MOUSE_FILTER_STOP)

	var vida = pinguino.vida
	var daño = pinguino.get_daño()
	panel.set_datos(vida, daño, pinguino)
