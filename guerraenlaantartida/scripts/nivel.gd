extends Node2D

var pinguino_preview = preload("res://escenas/pinguino_preview.tscn")
@onready var foca_escena = preload("res://escenas/foca_leopardo.tscn")

var conteo = 0
var pausa = false
var tiempo_total := 0
var tiempo_actual := 0.0
var tiempo_ultimo_spawn := 0.0
var intervalo_spawn := 5.0
var intervalo_spawn_min := 5.0
var intervalo_spawn_max := 5.0
var seguirGenerando := false
var nivel_iniciado := false
var generacion_terminada := false

var cooldown_duracion := 5.0
var cooldown_tiempo := 0.0
var en_cooldown := false

var nivelActual
var datos_nivel: Dictionary

var check_timer: Timer

func _ready():
	nivelActual = Global.nivelActual
	$TextoSeAcercaWave.hide()
	$IniciarNivel.hide()
	$OleadaFinal.hide()
	
	randomize()
	cargar_datos_nivel(nivelActual)
	$BarraProgreso._actualizar_tiempo(tiempo_total)
	$AnimationPlayer.play("iniciar_nivel")
	
	Engine.time_scale = 1.0
	get_tree().paused = false
	Global.peces = 10
	Global.pecesDorados = 5
	_actualizar_label_peces()
	_actualizar_label_peces_dorados()
	set_process_unhandled_input(true)
	$Menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("nivel")

	var boton = $BotonPausa_Play
	boton.texture_normal = preload("res://img/botonpausa.png")

func _process(delta):
	if pausa or !nivel_iniciado:
		return

	if tiempo_actual <= tiempo_total:
		tiempo_actual += delta

		if tiempo_actual - tiempo_ultimo_spawn >= intervalo_spawn:
			generar_enemigos()
			tiempo_ultimo_spawn = tiempo_actual
			intervalo_spawn = randf_range(intervalo_spawn_min, intervalo_spawn_max)
	else:
		seguirGenerando = false
		if not generacion_terminada:
			generacion_terminada = true
			fin_generacion()

	if $Pinguinos.get_child_count() > 0:
		$Pinguinos.get_child(0).global_position = get_global_mouse_position()

	conteo = $Pinguinos.get_child_count()

	if en_cooldown:
		cooldown_tiempo += delta
		var progreso = clamp((cooldown_tiempo / cooldown_duracion) * 100.0, 0, 100)
		$Control/TextureProgressBar.value = progreso

		if progreso >= 100.0:
			en_cooldown = false
			$Control/Button.disabled = false

func iniciar_nivel():
	nivel_iniciado = true
	seguirGenerando = true
	generacion_terminada = false
	tiempo_actual = 0.0
	tiempo_ultimo_spawn = 0.0
	intervalo_spawn = randf_range(intervalo_spawn_min, intervalo_spawn_max)
	$Control/TextureProgressBar.value = 0
	$BarraProgreso._actualizar_tiempo(tiempo_total)
	$BarraProgreso.iniciar_nivel()
	
	generar_enemigos()

func fin_generacion():
	$AnimationPlayer.play("se acerca una oleada")
	await get_tree().create_timer(4.0).timeout 
	generar_oleada_final() 

func generar_oleada_final():
	$AnimationPlayer.play("oleada final")
	if nivelActual == 1:
		oleada_final_nivel_uno()
	iniciar_comprobacion_path_vacios()

func oleada_final_nivel_uno():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

func generar_enemigos():
	if seguirGenerando:
		var numero = randi_range(1, 5)
		var path = get_node("%d" % numero)

		if path and datos_nivel.has("enemigos"):
			var lista_enemigos = datos_nivel["enemigos"]
			if lista_enemigos.size() > 0:
				var enemigo_seleccionado = lista_enemigos[randi() % lista_enemigos.size()]
				var escena_path = "res://escenas/%s.tscn" % enemigo_seleccionado
				if ResourceLoader.exists(escena_path):
					var enemigo_escena = load(escena_path)
					var enemigo = enemigo_escena.instantiate()
					path.add_child(enemigo)
					enemigo.rotation_degrees = 90
					enemigo.progress_ratio = 0
				else:
					print("No se encontró la escena para:", enemigo_seleccionado)
		else:
			print("No se encontró el nodo con nombre:", numero)
	else:
		print("Generación de enemigos detenida")

func _on_button_pressed():
	if conteo == 0 and Global.peces >= 5 and !en_cooldown:
		Global.modo_compra = true
		var preview = pinguino_preview.instantiate()
		$Pinguinos.add_child(preview)
		_actualizar_label_peces()

		en_cooldown = true
		cooldown_tiempo = 0.0
		$Control/TextureProgressBar.value = 0
		$Control/TextureProgressBar.tint_under = Color(1, 1, 1, 0.5)
		$Control/Button.disabled = true
	elif Global.peces < 5:
		print("No tienes suficientes peces para comprar un pingüino.")

func _reset():
	if $Pinguinos.get_child_count() > 0:
		$Pinguinos.get_child(0).queue_free()

func _actualizar_label_peces():
	$ContadorPecesNormales/ConteoPeces.text = str(Global.peces)

func _actualizar_label_peces_dorados():
	$ContadorPecesDorados/ConteoPecesDorados.text = str(Global.pecesDorados)

func _unhandled_input(event):
	if event.is_action_pressed("abrirmenu"):
		toggle_pause()

func toggle_pause():
	pausa = !pausa
	get_tree().paused = pausa
	$Menu.visible = pausa

func terminarjuego():
	Engine.time_scale = 0.0
	$MenuDerrota.show()

func _on_timer_timeout():
	$Control/TextureProgressBar.value += 20

	if $Control/TextureProgressBar.value >= 100:
		$Control/Timer.stop()
		$Control/Button.disabled = false

func cargar_datos_nivel(nivel):
	var archivo := FileAccess.open("res://archivos/info_niveles.json", FileAccess.READ)
	if archivo:
		var contenido := archivo.get_as_text()
		var json := JSON.new()
		var resultado := json.parse(contenido)

		if resultado == OK:
			var niveles: Array = json.data
			if niveles is Array:
				for nivel_data in niveles:
					if nivel_data.has("nivel") and nivel_data["nivel"] == nivelActual:
						datos_nivel = nivel_data
						configurar_nivel()
						tiempo_total = datos_nivel["duracion"]

						# Leer intervalo_spawn si existe
						if datos_nivel.has("intervalo_spawn") and typeof(datos_nivel["intervalo_spawn"]) == TYPE_ARRAY and datos_nivel["intervalo_spawn"].size() == 2:
							intervalo_spawn_min = float(datos_nivel["intervalo_spawn"][0])
							intervalo_spawn_max = float(datos_nivel["intervalo_spawn"][1])
						else:
							# Si no existe, usar un valor fijo por defecto
							intervalo_spawn_min = 5.0
							intervalo_spawn_max = 5.0

						return
				print("Nivel no encontrado en el archivo JSON.")
			else:
				print("Formato de JSON inválido. Se esperaba un Array.")
		else:
			print("Error al parsear el JSON: ", json.get_error_message())
	else:
		print("No se pudo abrir el archivo niveles.json.")

func configurar_nivel():
	if datos_nivel:
		print("Configurando el nivel:")
		print("Nivel: ", datos_nivel["nivel"])
		print("Enemigos: ", datos_nivel["enemigos"])
		print("Duración: ", datos_nivel["duracion"], " segundos")
		if datos_nivel.has("intervalo_spawn"):
			print("Intervalo spawn: ", datos_nivel["intervalo_spawn"])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "iniciar_nivel":
		iniciar_nivel()

func iniciar_comprobacion_path_vacios():
	# Crear un Timer si no existe aún
	if not check_timer:
		check_timer = Timer.new()
		check_timer.wait_time = 2.0
		check_timer.autostart = true
		check_timer.one_shot = false
		check_timer.timeout.connect(_comprobar_paths_vacios)
		add_child(check_timer)

func _comprobar_paths_vacios():
	var todos_vacios = true

	for child in get_children():
		if child is Path2D:
			if child.get_child_count() > 0:
				todos_vacios = false
				break 
	if todos_vacios:
		ganar()
		
func ganar():
	if Global.nivelActual > Global.nivelMaximoConseguido:
		Global.nivelMaximoConseguido = Global.nivelActual
		Global.nivelActual = Global.nivelActual + 1
	for area in get_tree().get_nodes_in_group("proyectil"):
		if area is Area2D and area.get_parent():
			area.get_parent().queue_free()
	$MenuVictoria.show()
	$MenuVictoria.animar_dinero()
