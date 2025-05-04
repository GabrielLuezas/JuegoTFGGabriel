extends Node2D

var pinguino_preview = preload("res://escenas/pinguino_preview.tscn")
@onready var foca_escena = preload("res://escenas/foca.tscn")

var conteo = 0
var pausa = false
var tiempo_total := 0
var tiempo_actual := 0.0
var tiempo_ultimo_spawn := 0.0
var intervalo_spawn := 5.0 
var seguirGenerando := true

var cooldown_duracion := 5.0
var cooldown_tiempo := 0.0
var en_cooldown := false


func _ready():
	randomize()
	tiempo_total = $BarraProgreso/BarraProgreso.max_value +1
	Engine.time_scale = 1.0
	get_tree().paused = false
	$"/root/Global".peces = 40
	$"/root/Global".pecesDorados = 5
	_actualizar_label_peces()
	_actualizar_label_peces_dorados()
	set_process_unhandled_input(true)
	$Menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("nivel")

	var boton = $BotonPausa_Play
	boton.texture_normal = preload("res://img/botonpausa.png")

func _process(delta):
	if pausa:
		return

	if tiempo_actual <= tiempo_total:
		tiempo_actual += delta


		if tiempo_actual - tiempo_ultimo_spawn >= intervalo_spawn:
			generar_enemigos()
			tiempo_ultimo_spawn = tiempo_actual
	else:
		seguirGenerando = false

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

func generar_enemigos():
	if seguirGenerando:
		var numero = randi_range(1, 5)
		var path = get_node("%d" % numero)

		if path:
			var foca = foca_escena.instantiate()
			path.add_child(foca)
			foca.rotation_degrees = 90 
			foca.progress_ratio = 0
		else:
			print("No se encontró el nodo con nombre:", numero)
	else:
		print("Se acabó la generación")

func _on_button_pressed():
	if conteo == 0 and Global.peces >= 5 and !en_cooldown:
		Global.modo_compra = true
		var preview = pinguino_preview.instantiate()
		$Pinguinos.add_child(preview)
		_actualizar_label_peces()
		
		en_cooldown = true
		cooldown_tiempo = 0.0
		$Control/TextureProgressBar.value = 0
		$Control/TextureProgressBar.tint_under = Color(1,1,1,0.5)
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
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://escenas/game_over.tscn")

func _on_timer_timeout():
	# Sube 20% cada vez que se llama
	$Control/TextureProgressBar.value += 20

	# Cuando llega a 100, se detiene el cooldown
	if $Control/TextureProgressBar.value >= 100:
		$Control/Timer.stop()
		$Control/Button.disabled = false
