extends Control
var ruta = "res://escenas/interior_casa_normal.tscn"

var full_text := "Bienvenido al campamento central, estratega. Esta es nuestra base de operaciones, el centro de mando y el punto clave que debes proteger a toda costa."
var type_speed := 0.03
var paso_actual = 1

var temporizador_flechas = Timer.new()
var mostrar_a = true
var flechas_a = null
var flechas_b = null

func _ready() -> void:
	Global.musica_inicio.stop()
	Engine.time_scale = 1.0
	Global.reproducir_musica("res://sonidos/musicas/MusicaCampamento.ogg")
	Global.manejar_musica_por_escena("res://escenas/campamento_principal.tscn")
	
	if Global.nivelMaximoConseguido >= 2:
		$Botones/BotonTienda.show()
	else:
		$Botones/BotonTienda.hide()
	
	if Global.explicarCampamento:
		$PinguPescador.show()
		$BotonPinguinoPescador.show()
		$ExplicarCampamento.show()
		$Botones.hide()
		show_text_slowly_campamento(full_text)


func _process(delta: float) -> void:
	pass


func _on_boton_tienda_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/tienda_escena.tscn")


func _on_boton_casa_jefe_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/interior_casa_jefe.tscn")


func _on_boton_casa_1_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_2_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_3_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_4_dcha_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_1_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_2_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_3_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)


func _on_boton_casa_4_izq_pressed() -> void:
	get_tree().change_scene_to_file(ruta)
	
func show_text_slowly_campamento(text: String) -> void:
	await _reveal_text_campamento(text) 

func _reveal_text_campamento(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$ExplicarCampamento/TextoTutorialCampamento.text = current
		await get_tree().create_timer(type_speed).timeout
	$ExplicarCampamento/ClicParaContinuar.show()
	$ExplicarCampamento/Continuar.show()


func _on_continuar_pressed() -> void:
	$ExplicarCampamento/ClicParaContinuar.hide()
	$ExplicarCampamento/Continuar.hide()

	if paso_actual == 1:
		$ExplicarCampamento/IgluJefe.show()
		full_text = "Esta es mi casa y también el centro de operaciones. Si estás listo para el siguiente nivel, entra y pulsa sobre el mapa que está sobre la mesa."
		paso_actual = 2
		show_text_slowly_campamento(full_text)

	elif paso_actual == 2:
		$ExplicarCampamento/IgluJefe.hide()
		$ExplicarCampamento/IgluTienda.show()
		full_text = "Esta es la tienda de Gunter, pero por ahora está cerrada. Gunter no se encuentra en la aldea… aunque dicen que volverá pronto."
		paso_actual = 3
		show_text_slowly_campamento(full_text)

	elif paso_actual == 3:
		$ExplicarCampamento/IgluTienda.hide()
		full_text = "El resto son casas de civiles que se refugiaron en el campamento después de que sus aldeas fueran atacadas por esas malditas focas. ¡Debemos detenerlas cuanto antes!"
		paso_actual = 4
		show_text_slowly_campamento(full_text)

	elif paso_actual == 4:
		full_text = "Antes de que vayas al siguiente nivel, necesitarás a alguien que te ayude con la recolección de peces. No siempre podré dártelos yo. Habla con el pingüino que está junto al estanque."
		paso_actual = 5
		show_text_slowly_campamento(full_text)

	elif paso_actual == 5:
		$ExplicarCampamento.hide()
		Global.explicarCampamento = false
		$BotonPinguinoPescador.show()
		flechas_a = $Flechas1
		flechas_b = $Flechas2
		iniciar_animacion_flechas()



func iniciar_animacion_flechas():
	temporizador_flechas.wait_time = 0.5  
	temporizador_flechas.one_shot = false
	temporizador_flechas.autostart = true
	add_child(temporizador_flechas)
	temporizador_flechas.timeout.connect(_al_cambiar_tiempo)

# Alternar visibilidad entre A y B
func _al_cambiar_tiempo():
	mostrar_a = !mostrar_a
	if mostrar_a:
		flechas_a.show()
		flechas_b.hide()
	else:
		flechas_a.hide()
		flechas_b.show()

func _on_boton_pinguino_pescador_pressed() -> void:
	var escena_nueva = preload("res://escenas/dialogo_pescador.tscn").instantiate() 
	$Marker2D.add_child(escena_nueva)
	await escena_nueva.cerrado
	$Flechas1.hide()
	$Flechas2.hide()
	$Botones.show()
	$Botones/BotonTienda.hide()
	$Botones/BotonCasa1Dcha.hide()
	$Botones/BotonCasa2Dcha.hide()
	$Botones/BotonCasa3Dcha.hide()
	$Botones/BotonCasa4Dcha.hide()
	$Botones/BotonCasa1Izq.hide()
	$Botones/BotonCasa2Izq.hide()
	$Botones/BotonCasa3Izq.hide()
	$Botones/BotonCasa4Izq.hide()
	$PinguPescador.hide()
	$BotonPinguinoPescador.hide()
	flechas_a = $FlechasCasaJefe1
	flechas_b = $FlechasCasaJefe2
	$FlechasCasaJefe1.show()
	$FlechasCasaJefe2.show()


func _unhandled_input(event):
	if event.is_action_pressed("abrirmenu"):
		var menu_existente = get_tree().current_scene.get_node_or_null("MenuNoIngame")
		
		if menu_existente:
			menu_existente.queue_free()  # Cierra el menú
		else:
			var escena_menu = preload("res://escenas/menu_no_ingame.tscn")
			var menu = escena_menu.instantiate()
			menu.name = "MenuNoIngame"  # Para poder detectarlo luego
			get_tree().current_scene.add_child(menu)
		
