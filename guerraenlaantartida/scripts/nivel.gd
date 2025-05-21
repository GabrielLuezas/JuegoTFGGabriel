extends Node2D

var pinguino_preview = preload("res://escenas/pinguino_preview.tscn")
@onready var foca_escena = preload("res://escenas/foca_leopardo.tscn")
@onready var foca_escena_chaleco = preload("res://escenas/foca_leopardo_chaleco.tscn")
@onready var foca_escena_chaleco_casco = preload("res://escenas/foca_leopardo_chaleco_casco.tscn")
@onready var foca_escena_blindada = preload("res://escenas/foca_blindada.tscn")
@onready var foca_escena_payaso = preload("res://escenas/foca_payaso.tscn")
@onready var foca_escena_hielo = preload("res://escenas/foca_hielo.tscn")
@onready var foca_escena_ignea = preload("res://escenas/foca_ignea.tscn")
@onready var boss_escena = preload("res://escenas/foca_boss.tscn")


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
var ganado := false
var nivelboss = false

var cooldown_duracion := 5.0
var cooldown_tiempo := 0.0
var en_cooldown := false

var nivelActual
var datos_nivel: Dictionary

var check_timer: Timer

var full_text := "Oh, así que tú eres nuestro nuevo estratega.\nBienvenido al frente de batalla, %s. Aquí no hay tiempo para descansar, tu misión será defender nuestro territorio de los enemigos que no dejan de avanzar." % Global.nombreUsuario
var type_speed := 0.03
var siguiente_paso_tutorial = false
var paso_enseñar_pinguino = false
var paso_enseñar_peces = false
var paso_enseñar_menus_abajo = false
var paso_enseñar_menus_abajo2 = false
var paso_enseñar_tablero = false
var paso_final_tutorial = false
var paso_enseñar_escape = false

var temporizador_flechas = Timer.new()
var mostrar_a = true
var flechas_a = null
var flechas_b = null

var paso_tutorial_victoria = 0
var paso_tutorial_derrota = 0

var tutorial2_pasos = 1
var tutorial3_pasos = 1
var tutorial4_pasos = 1

var type_speed_ganar_boss := 0.05
var mensaje_victoria_boss = "¡Has conseguido derrotar al jefe de las focas! A partir de ahora, los pingüinos volverán a reinar.\nGracias por salvarnos,\n%s." % Global.nombreUsuario

func _ready():
	nivelActual = Global.nivelActual
	Global.peces = 0
	Global.pecesDorados = 0
	_actualizar_label_peces()
	_actualizar_label_peces_dorados()
	
	
	
	$Pez.hide()
	$PezDorado.hide()
	if nivelActual == 1:
		$ContadorPecesDorados.hide()
		$Pesca.hide()
		if Global.tutorialNivel1:
			Global.peces= 30
			_actualizar_label_peces()
			$AudioStreamPlayer2D.play()
			$AnimationPlayer.play("iniciar_nivel")
		else:
			$TutorialNivel1.show()
			$MusicaTuto.play()
			$AnimationPlayer.play("moversensei")
	if nivelActual == 2:
		$ContadorPecesDorados.hide()
		$Pesca.hide()
		$TutorialNivel2/PinguPescadorIcono.show()
		if Global.tutorialNivel2:
			$Pesca.show()
			$AudioStreamPlayer2D.play() 
			$AnimationPlayer.play("iniciar_nivel")
		else: 
			full_text = "Parece que has tenido éxito encontrando a un pescador. Proxing es uno de los mejores de la aldea, ¡seguro que te será muy útil en el campo de batalla!"
			$TutorialNivel2.show()
			$MusicaTuto.play()
			$AnimationPlayer.play("moversensei_2")
	if nivelActual == 3:
		$ContadorPecesDorados.hide()
		$Pesca.hide()
		if Global.tutorialNivel3:
			$Pesca.show()
			$ContadorPecesDorados.show()
			$AudioStreamPlayer2D.play()
			Global.pecesDorados = 3
			_actualizar_label_peces_dorados()
			$AnimationPlayer.play("iniciar_nivel")
		else: 
			$MusicaTuto.play()
			full_text = "Los pingüinos reales aún pueden volverse más fuertes. Estos tienen mejoras que cuestan 1 pez de oro cada una."
			$TutorialNivel3.show()
			show_text_slowly_tuto3(full_text)
			flechas_a = $TutorialNivel3/FlechasPeces
			flechas_b = $TutorialNivel3/FlechasPeces2
			$ContadorPecesDorados.show()
			iniciar_animacion_flechas()
	if nivelActual >= 4 and nivelActual <=11:
		$Pesca.show()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("iniciar_nivel")
	if nivelActual == 12:
		$Pesca.show()
		nivelboss = true
		$AudioStreamPlayer2D.play()
		nivel_iniciado = true
		iniciarBoss()
	
	if nivelActual >= 3:
		comprobar_mejoras()
	
	$TextoSeAcercaWave.hide()
	$IniciarNivel.hide()
	$OleadaFinal.hide()
	
	randomize()
	cargar_datos_nivel(nivelActual)
	$BarraProgreso._actualizar_tiempo(tiempo_total)
	
	Engine.time_scale = 1.0
	get_tree().paused = false
	_actualizar_label_peces()
	_actualizar_label_peces_dorados()
	set_process_unhandled_input(true)
	$Menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("nivel")

	var boton = $BotonPausa_Play
	boton.texture_normal = preload("res://img/botonpausa.png")
	
func _process(delta):
	
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
	
	if nivelboss:
		return
	
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

func iniciarBoss():
	$AnimationPlayer.play("iniciar_nivel_boss")
	await get_tree().create_timer(5.0).timeout
	var path_boss = get_node("3")
	if path_boss:
		var boss = boss_escena.instantiate()
		path_boss.add_child(boss)
		boss.rotation_degrees = 90
		boss.progress_ratio = 0
		boss.fase = 1
		boss.set_detenido(true)
		boss.hacer_fase()



func iniciar_nivel():
	nivel_iniciado = true
	seguirGenerando = true
	generacion_terminada = false
	tiempo_actual = 0.0
	tiempo_ultimo_spawn = 0.0
	intervalo_spawn = randf_range(intervalo_spawn_min, intervalo_spawn_max)
	$BarraProgreso.show()
	$Control/TextureProgressBar.value = 0
	$BarraProgreso._actualizar_tiempo(tiempo_total)
	$BarraProgreso.iniciar_nivel()
	
	await get_tree().create_timer(5.0).timeout
	generar_enemigos()

func fin_generacion():
	$AnimationPlayer.play("se acerca una oleada")
	await get_tree().create_timer(4.0).timeout 
	$TextoSeAcercaWave.hide()
	generar_oleada_final() 

func generar_oleada_final():
	$AnimationPlayer.play("oleada final")
	if nivelActual == 1:
		oleada_final_nivel_uno()
	if nivelActual == 2:
		oleada_final_nivel_dos()
	if nivelActual == 3:
		oleada_final_nivel_tres()
	if nivelActual == 4:
		oleada_final_nivel_cuatro()
	if nivelActual == 5:
		oleada_final_nivel_cinco()
	if nivelActual == 6:
		oleada_final_nivel_seis()
	if nivelActual == 7:
		oleada_final_nivel_siete()
	if nivelActual == 8:
		oleada_final_nivel_ocho()
	if nivelActual == 9:
		oleada_final_nivel_nueve()
	if nivelActual == 10:
		oleada_final_nivel_diez()
	if nivelActual == 11:
		oleada_final_nivel_once()
	$OleadaFinal.hide()
	await get_tree().create_timer(4.0).timeout
	iniciar_comprobacion_path_vacios()

func oleada_final_nivel_uno():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
func oleada_final_nivel_dos():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca
			foca = foca_escena_chaleco.instantiate()  # Foca con chaleco
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

	await get_tree().create_timer(3.0).timeout

	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena.instantiate()  # Foca normal
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
			
func oleada_final_nivel_tres():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

	await get_tree().create_timer(4.0).timeout

	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca
			if i == 3: 
				foca = foca_escena.instantiate()
			else:
				foca = foca_escena_chaleco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
func oleada_final_nivel_cuatro():
	# Primera parte: todas focas blindadas
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

	await get_tree().create_timer(3.0).timeout

	# Segunda parte: todas focas con chaleco (sin casco)
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

func oleada_final_nivel_cinco():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0

	await get_tree().create_timer(3.0).timeout

	# Segunda parte: todas focas con chaleco (sin casco)
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(5.0).timeout

	# Segunda parte: todas focas con chaleco (sin casco)
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
func oleada_final_nivel_seis():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(1.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(1.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(1.0).timeout
	generar_foca_payaso()
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
func oleada_final_nivel_siete():
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(2.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(2.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(2.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(2.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(2.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
func oleada_final_nivel_ocho():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	pass
func oleada_final_nivel_nueve():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(6.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	pass
func oleada_final_nivel_diez():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
func oleada_final_nivel_once():
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_chaleco_casco.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	generar_foca_payaso()
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_blindada.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(6.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_ignea.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var foca = foca_escena_hielo.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90
			foca.progress_ratio = 0
	await get_tree().create_timer(3.0).timeout
	
func generar_enemigos():
	if seguirGenerando:
		var numero = randi_range(1, 5)
		var path = get_node("%d" % numero)

		if path and datos_nivel.has("enemigos"):
			var lista_enemigos = datos_nivel["enemigos"]
			if lista_enemigos.size() > 0:
				var enemigo_seleccionado = lista_enemigos[randi() % lista_enemigos.size()]
				
				if enemigo_seleccionado == "foca_payaso":
					generar_foca_payaso()
					return
				
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


func generar_foca_payaso():
	$SonidoPayaso.play()
	await get_tree().create_timer(2.0).timeout
	for i in range(1, 6):
		var path = get_node("%d" % i)
		if path:
			var escena_path = "res://escenas/foca_payaso.tscn"
			if ResourceLoader.exists(escena_path):
				var enemigo_escena = load(escena_path)
				var enemigo = enemigo_escena.instantiate()
				path.add_child(enemigo)
				enemigo.rotation_degrees = 90
				enemigo.progress_ratio = 0
			else:
				print("No se encontró la escena para: foca_payaso")


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
	$Menu.visible = pausa
	get_tree().paused = pausa

func toggle_pausa_menu_libro():
	get_tree().paused = pausa
	
func terminarjuego(nombre_path):
	if Global.mejoraSenseiPinguino and Global.cargasSensei==1:
		Global.cargasSensei = 0
		match nombre_path:
			"1":
				$PinguMaestro.position = Vector2(296, 88)
				$PinguMaestro.show()
				eliminar_enemigos_de_linea(nombre_path)
				await get_tree().create_timer(3.0).timeout
				$PinguMaestro.hide()
			"2":
				$PinguMaestro.position = Vector2(296, 175)
				$PinguMaestro.show()
				eliminar_enemigos_de_linea(nombre_path)
				await get_tree().create_timer(3.0).timeout
				$PinguMaestro.hide()
			"3":
				$PinguMaestro.position = Vector2(296, 255)
				$PinguMaestro.show()
				eliminar_enemigos_de_linea(nombre_path)
				await get_tree().create_timer(3.0).timeout
				$PinguMaestro.hide()
			"4":
				$PinguMaestro.position = Vector2(296, 331)
				$PinguMaestro.show()
				eliminar_enemigos_de_linea(nombre_path)
				await get_tree().create_timer(3.0).timeout
				$PinguMaestro.hide()
			"5":
				$PinguMaestro.position = Vector2(296, 412)
				$PinguMaestro.show()
				eliminar_enemigos_de_linea(nombre_path)
				await get_tree().create_timer(3.0).timeout
				$PinguMaestro.hide()
			_:
				print("Llegó por otro camino: ", nombre_path)
	else:
		$AudioStreamPlayer2D.stop()
		for area in get_tree().get_nodes_in_group("proyectil"):
				if area is Area2D and area.get_parent():
					area.get_parent().queue_free()
		$MenuDerrota.show()
		$Perder.play()
		Engine.time_scale = 0.0

func eliminar_enemigos_de_linea(nombre_path):
	var path = get_node_or_null(NodePath(nombre_path))
	if path == null:
		print("No se encontró el path: ", nombre_path)
		return

	for child in path.get_children():
		if child is PathFollow2D and child.name != "foca_boss":
			child.queue_free()

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
	if anim_name == "moversensei":
		show_text_slowly(full_text)
	if anim_name == "moversensei_2":
		show_text_slowly_tuto2(full_text)
	if anim_name == "explicarUnidades":
		var full_text := "Estas son nuestras tropas: los Pingüinos Reales.\nEntrenados como verdaderos soldados para proteger el pueblo de cualquier amenaza.\n\nPero cuidado... ¡desplegar soldados no es gratis!\nNecesitas al menos 5 peces para enviar uno al campo de batalla."
		flechas_a = $TutorialNivel1/FlechasPingu1
		flechas_b = $TutorialNivel1/FlechasPingu2
		iniciar_animacion_flechas()
		show_text_slowly(full_text)
	if anim_name == "explicar_menus_parte_inferior":
		var full_text := "Puedes pausar la partida con este botón de aquí abajo.\nSi necesitas un respiro y planificar la siguiente jugada, puedes pausar en cualquier momento."
		flechas_a = $TutorialNivel1/FlechasBotonPausa
		flechas_b = $TutorialNivel1/FlechasBotonPausa2
		$TutorialNivel1/FlechasPeces.hide()
		$TutorialNivel1/FlechasPeces2.hide()
		$TutorialNivel1/IconoPausaTutorial.show()
		show_text_slowly(full_text)
	if anim_name == "explicar_terreno_juego":
		var full_text := "Este es el campo de batalla.\nAquí deberás colocar a tus soldados para defender la aldea."
		$TutorialNivel1/ImagenCampoBatalla.show()
		show_text_slowly(full_text)
	if anim_name == "final_tutorial":
		var full_text := "Y eso es todo. Te voy a dar unos cuantos peces para que comiences a defender"
		show_text_slowly(full_text)
	if anim_name == "dar_peces":
		Global.peces = 30
		_actualizar_label_peces()
		$TutorialNivel1.hide()
		$MusicaTuto.stop()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("iniciar_nivel")
		
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
	if todos_vacios and !ganado:
		ganado = true
		$AudioStreamPlayer2D.stop()
		ganar()
		
		
func ganar():
	if nivelActual == 12 and  Global.nivelMaximoConseguido==11: 
		Global.nivelMaximoConseguido = 12
		$TerminarJuego.show()
		$TerminarJuego/TerminarJuegbo.play("terminarjuego")
	else:
		if nivelActual == 1 and !Global.tutorialNivel1:
			Global.tutorialNivel1 = true
			if Global.nivelActual > Global.nivelMaximoConseguido:
				Global.nivelMaximoConseguido = Global.nivelActual
				Global.nivelActual = Global.nivelActual + 1
			for area in get_tree().get_nodes_in_group("proyectil"):
				if area is Area2D and area.get_parent():
					area.get_parent().queue_free()
			Engine.time_scale = 1.0
			$MenuVictoria.show()
			$TutorialPrimeraVictoria.show()
			$MenuVictoria/VBoxContainer/SiguienteNivel.disabled = true
			$MenuVictoria/VBoxContainer/CampamentoPrincipal.disabled = true
			full_text = "¡Impresionante! Has logrado defender la aldea con éxito."
			show_text_slowly_victoria(full_text)
		elif nivelActual == 2:
			Global.tutorialNivel2 = true
			for area in get_tree().get_nodes_in_group("proyectil"):
				if area is Area2D and area.get_parent():
					area.get_parent().queue_free()
			Engine.time_scale = 1.0
			$MenuVictoria.show()
			$Ganar.play()
			$TutorialPrimeraVictoria.show()
			paso_tutorial_victoria= 10
			full_text = "Gunter ha vuelto a la aldea. Te recomiendo visitarlo."
			show_text_slowly_victoria(full_text)
			
			if Global.nivelActual > Global.nivelMaximoConseguido:
				Global.nivelMaximoConseguido = Global.nivelActual
				Global.nivelActual = Global.nivelActual + 1
				$MenuVictoria.animar_dinero()
		else:
			for area in get_tree().get_nodes_in_group("proyectil"):
				if area is Area2D and area.get_parent():
					area.get_parent().queue_free()
			Engine.time_scale = 1.0
			$MenuVictoria.show()
			$Ganar.play()
			if Global.nivelActual > Global.nivelMaximoConseguido:
				Global.nivelMaximoConseguido = Global.nivelActual
				Global.nivelActual = Global.nivelActual + 1
				$MenuVictoria.animar_dinero()

func show_text_slowly(text: String) -> void:
	await _reveal_text(text)

func _reveal_text(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$TutorialNivel1/Texto1.text = current
		await get_tree().create_timer(type_speed).timeout
	$TutorialNivel1/ClicParaContinuar.show()
	$TutorialNivel1/Continuar.show()


func _on_continuar_pressed() -> void:
	$TutorialNivel1/ClicParaContinuar.hide()
	$TutorialNivel1/Continuar.hide()
	if siguiente_paso_tutorial :
		if paso_enseñar_pinguino :
			temporizador_flechas.stop()
			$TutorialNivel1/TarjetaPinguino.hide()
			$TutorialNivel1/FlechasPingu1.hide()
			$TutorialNivel1/FlechasPingu2.hide()
			if paso_enseñar_peces :
				if paso_enseñar_menus_abajo:
					temporizador_flechas.stop()
					if paso_enseñar_menus_abajo2:
						temporizador_flechas.stop()
						if paso_enseñar_tablero:
							if paso_enseñar_escape:
								if paso_final_tutorial:
									$AnimationPlayer.play("dar_peces")
								else:
									paso_final_tutorial  = true
									$AnimationPlayer.play("final_tutorial")
							else:
								$TutorialNivel1/ImagenCampoBatalla.hide()
								$TutorialNivel1/PecesContadorTutorial.show()
								paso_enseñar_escape=true
								full_text = "Pulsa la tecla Escape para abrir el menú. Esto también pausará la partida."
								show_text_slowly(full_text)
						else:
							$TutorialNivel1/IconosVelocidad.hide()
							$TutorialNivel1/FlechasBotonVelocidad.hide()
							$TutorialNivel1/FlechasBotonVelocidad2.hide()
							$TutorialNivel1/Texto1.text = ""
							$AnimationPlayer.play("explicar_terreno_juego")
							paso_enseñar_tablero = true
					else:
						$TutorialNivel1/FlechasBotonPausa2.hide()
						$TutorialNivel1/FlechasBotonPausa.hide()
						$TutorialNivel1/IconoPausaTutorial.hide()
						paso_enseñar_menus_abajo2 = true
						flechas_a = $TutorialNivel1/FlechasBotonVelocidad
						flechas_b = $TutorialNivel1/FlechasBotonVelocidad2
						$TutorialNivel1/IconosVelocidad.show()
						temporizador_flechas.start()
						full_text = "También puedes aumentar la velocidad del juego pulsando los botones x1, x2 o x3,\nen caso de que quieras ir más rápido porque ya tienes una buena línea de defensa."
						show_text_slowly(full_text)
				else:
					$TutorialNivel1/FlechasPeces.hide()
					$TutorialNivel1/FlechasPeces2.hide()
					$TutorialNivel1/PecesContadorTutorial.hide()
					$TutorialNivel1/Texto1.text = ""
					$AnimationPlayer.play("explicar_menus_parte_inferior")
					paso_enseñar_menus_abajo = true
					temporizador_flechas.start()
			else:
				paso_enseñar_peces = true
				$TutorialNivel1/PecesContadorTutorial.show()
				flechas_a = $TutorialNivel1/FlechasPeces
				flechas_b = $TutorialNivel1/FlechasPeces2
				temporizador_flechas.start()
				
				full_text = "Los peces son el recurso básico del que disponemos. Con ellos podemos desplegar más Pingüinos Reales que nos ayudan en la defensa.\nCuantas más tropas coloques, más fácil será repeler a todos los enemigos."
				show_text_slowly(full_text)
		else:
			$AnimationPlayer.play("explicarUnidades")
			paso_enseñar_pinguino= true
	else:
		full_text = "Pero tranquilo, no estás solo.\nVoy a explicarte un poco los elementos disponibles, para que no te pillen desprevenido..."
		show_text_slowly(full_text)
		siguiente_paso_tutorial = true


func iniciar_animacion_flechas():
	temporizador_flechas.wait_time = 0.5  # Cambiar cada medio segundo
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

func comprobar_mejoras():
	if Global.mejoraSenseiPinguino:
		Global.cargasSensei = 1
	if Global.mejoraCañaVieja:
		$Pesca.min_tiempo_espera = 6.0
		$Pesca.max_tiempo_espera = 7.0
	if Global.mejoraCañaBuena:
		$Pesca.min_tiempo_espera = 5.0
		$Pesca.max_tiempo_espera = 6.0
	if Global.mejoraSuperCaña:
		$Pesca.min_tiempo_espera = 4.0
		$Pesca.max_tiempo_espera = 5.0
	if Global.mejoraPinguinoPescadorExtra1:
		$Pesca2.show()
	if Global.mejoraPinguinoPescadorExtra2:
		$Pesca3.show()
	if Global.mejoraAnzueloDorado:
		$Pesca.probabilidad_pez_dorado = 0.15
		$Pesca2.probabilidad_pez_dorado = 0.15
		$Pesca3.probabilidad_pez_dorado = 0.15
	if Global.mejoraPescadosDoradosInicio:
		Global.pecesDorados = 1
	if Global.mejoraPescadosNormalesInicio:
		Global.peces = 5

func _on_continuar_tuto_victoria_pressed() -> void:
	if paso_tutorial_victoria == 1:
		$TutorialPrimeraVictoria/ClicParaContinuar.hide()
		$TutorialPrimeraVictoria/ContinuarTutoVictoria.hide()
		full_text = "Volvamos al campamento principal antes del siguiente nivel."
		await show_text_slowly_victoria(full_text)
		$TutorialPrimeraVictoria/ClicParaContinuar.hide()
		$TutorialPrimeraVictoria/ContinuarTutoVictoria.hide()
		Global.explicarCampamento = true
		$MenuVictoria/VBoxContainer/SiguienteNivel.disabled = true
		$MenuVictoria/VBoxContainer/CampamentoPrincipal.disabled = false
	elif paso_tutorial_victoria == 10:
		$TutorialPrimeraVictoria.hide()
	else:
		$TutorialPrimeraVictoria/ClicParaContinuar.hide()
		$TutorialPrimeraVictoria/ContinuarTutoVictoria.hide()
		paso_tutorial_victoria = 1
		full_text = "Después de ganar cada nivel, consigues dinero que puedes usar en la tienda."
		await show_text_slowly_victoria(full_text)
		$MenuVictoria.animar_dinero()

func show_text_slowly_victoria(text: String) -> void:
	await _reveal_text_victoria(text)  # ✅ Corrección aquí

func _reveal_text_victoria(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$TutorialPrimeraVictoria/TextoTutorialVictoria.text = current
		await get_tree().create_timer(type_speed).timeout
	$TutorialPrimeraVictoria/ClicParaContinuar.show()
	$TutorialPrimeraVictoria/ContinuarTutoVictoria.show()
	
	
func show_text_slowly_tuto2(text: String) -> void:
	await _reveal_text_tuto2(text)

func _reveal_text_tuto2(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$TutorialNivel2/Texto1.text = current
		await get_tree().create_timer(type_speed).timeout
	$TutorialNivel2/ClicParaContinuar.show()
	$TutorialNivel2/ContinuarTuto2.show()


func _on_continuar_tuto_2_pressed() -> void:
	if tutorial2_pasos == 1:
		$TutorialNivel2/PinguPescadorIcono.hide()
		$TutorialNivel2/PinguPescadoIconoHaPescado.show()
		$TutorialNivel2/ClicParaContinuar.hide()
		$TutorialNivel2/ContinuarTuto2.hide()
		full_text = "La pesca es un proceso lento, pero los pingüinos pescadores te avisarán cuando tengan un pescado. Cuando eso ocurra, haz clic para recogerlo, y luego volverán a empezar a pescar."
		tutorial2_pasos = 2
		await show_text_slowly_tuto2(full_text)  # <- AWAIT AQUÍ

	elif tutorial2_pasos == 2:
		$TutorialNivel2/ClicParaContinuar.hide()
		$TutorialNivel2/ContinuarTuto2.hide()
		full_text = "Y eso es lo básico. Tienes un poco de tiempo para entrenar antes de que aparezcan los enemigos de este nivel. ¡Buena suerte!"
		tutorial2_pasos = 3
		await show_text_slowly_tuto2(full_text)  # <- AWAIT AQUÍ

	elif tutorial2_pasos == 3:
		$Pesca.show()
		$TutorialNivel2.hide()
		Global.tutorialNivel2 = true
		$MusicaTuto.stop()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("iniciar_nivel")

func reproducir_animacion_para(nombre_nodo: String):
	var anim_player = $AnimationPlayerPinguinos
	match nombre_nodo:
		"Pesca":
			anim_player.play("anim_pesca1")
		"Pesca2":
			anim_player.play("anim_pesca2")
		"Pesca3":
			anim_player.play("anim_pesca3")

func reproducir_animacion_para_dorado(nombre_nodo: String):
	var anim_player = $AnimationPlayerPinguinos2
	match nombre_nodo:
		"Pesca":
			anim_player.play("anim_pesca1_dorado")
		"Pesca2":
			anim_player.play("anim_pesca2_dorado")
		"Pesca3":
			anim_player.play("anim_pesca3_dorado")


func _on_continuar_tuto_nivel_3_pressed() -> void:
	if tutorial3_pasos == 1:
		$TutorialNivel3/FlechasPeces.hide()
		$TutorialNivel3/FlechasPeces2.hide()
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		full_text = "Puedes conseguir estos peces con un 10% de probabilidad por cada pesca que realice un pingüino pescador."
		tutorial3_pasos = 2
		await show_text_slowly_tuto3(full_text)

	elif tutorial3_pasos == 2:
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		$TutorialNivel3/ColorRect.hide()
		temporizador_flechas.stop()
		$TutorialNivel3/FlechasPeces.hide()
		$TutorialNivel3/FlechasPeces2.hide()
		full_text = "Para aplicar una mejora, debes hacer clic sobre un pingüino y seleccionar la mejora que deseas. Haz clic sobre el pingüino que está en el tablero."
		await show_text_slowly_tuto3(full_text)
		var destino = $Tablero/HBoxContainer/VBoxContainer/PanelContainer3/Marker2D
		var pinguino_scene = preload("res://escenas/pinguino.tscn")
		var pinguino_instance = pinguino_scene.instantiate()
		destino.add_child(pinguino_instance)
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		var boton = pinguino_instance.get_node("BotonPinguino")  
		await boton.pinguino_clickeado
		tutorial3_pasos = 3
		$TutorialNivel3/TapaderaPanel.show()
		full_text = "Cada pingüino tiene 4 mejoras diferentes con efectos distintos, pero cuidado: un mismo pingüino solo puede tener un tipo de mejora activa a la vez."
		await show_text_slowly_tuto3(full_text)

	elif tutorial3_pasos == 3:
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ColorRect.hide()
		tutorial3_pasos = 4
		full_text = "Cada mejora puede ser mejorada hasta un máximo de 4 niveles, costando siempre 1 pez de oro por cada nivel que suba."
		await show_text_slowly_tuto3(full_text)
	elif tutorial3_pasos == 4:
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ColorRect.hide()
		temporizador_flechas.start()
		flechas_a = $TutorialNivel3/FlechasLibro1
		flechas_b = $TutorialNivel3/FlechasLibro2
		tutorial3_pasos = 5
		full_text = "También puedes consultar qué hacen estas mejoras haciendo clic en el ícono del libro dentro del panel."
		await show_text_slowly_tuto3(full_text)
	elif tutorial3_pasos == 5:
		temporizador_flechas.stop()
		$TutorialNivel3/FlechasLibro1.hide()
		$TutorialNivel3/FlechasLibro2.hide()
		$TutorialNivel3/ContinuarTutoNivel3.hide()
		$TutorialNivel3/ClicParaContinuar.hide()
		$TutorialNivel3/ColorRect.hide()
		var panel = $SitioMejorasPinguinos.get_node("panel_mejoras")
		panel._on_boton_cerrar_pressed()
		$TutorialNivel3/TapaderaPanel.hide()
		tutorial3_pasos = 6
		full_text = "Te voy a dar 3 peces dorados para que pruebes a mejorar a los pingüinos. ¡Prepárate, que ya vienen los enemigos!"
		await show_text_slowly_tuto3(full_text)
		$AnimationPlayerPinguinos.play("dar_peces_dorados_tutorial")
		await get_tree().create_timer(1.0).timeout
		Global.pecesDorados = 3
		_actualizar_label_peces_dorados()
	elif tutorial3_pasos == 6:
		$Pesca.show()
		$TutorialNivel3.hide()
		Global.tutorialNivel3 = true
		$MusicaTuto.stop()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("iniciar_nivel")


func show_text_slowly_tuto3(text: String) -> void:
	await _reveal_text_tuto3(text)

func _reveal_text_tuto3(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$TutorialNivel3/TextoTutorial3.text = current
		await get_tree().create_timer(type_speed).timeout
	$TutorialNivel3/ClicParaContinuar.show()
	$TutorialNivel3/ContinuarTutoNivel3.show()


func terminar_boss():
	Engine.time_scale = 1.0
	ganado = true
	$AudioStreamPlayer2D.stop()
	ganar()


func _on_terminar_juegbo_animation_finished(anim_name: StringName) -> void:
	if anim_name == "terminarjuego":
		show_text_slowly_final(mensaje_victoria_boss)
	if anim_name == "cambiaracreditos":
		get_tree().change_scene_to_file("res://escenas/pantalla_creditos.tscn")


func show_text_slowly_final(text: String) -> void:
	await _reveal_text_final(text)
	$TerminarJuego/TerminarJuegbo.play("cambiaracreditos")
	
func _reveal_text_final(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$TerminarJuego/Label.text = current
		await get_tree().create_timer(type_speed_ganar_boss).timeout
