extends Control

var escena_precargada: PackedScene = null
var _hilo_precarga: Thread = null
@onready var animation_player = $AnimationPlayer

@onready var label_nombre = $AnimacionInicio/LabelNombre
@onready var audio_maquina = $AnimacionInicio/AudioStreamPlayer2D

func _ready() -> void:
	get_tree().paused = false
	animation_player.animation_finished.connect(_on_animation_finished)
	$NombreJuego.hide()
	$NombreJuego2.hide()
	escribir_texto_maquina("Gabriel Luezas\npresenta . . .", 0.2)
	precargar_escena("res://escenas/archivos_de_guardado.tscn")
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err == OK:
		var volumen = config.get_value("audio", "volumen_musica", 100)
		_apply_volume(volumen)
	else:
		_apply_volume(100)  # Valor por defecto
	
func _apply_volume(value: float) -> void:
	var db = linear_to_db(value / 100.0)
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, db)
	
func _process(delta: float) -> void:
	pass

func precargar_escena(ruta: String):
	if _hilo_precarga and _hilo_precarga.is_alive():
		_hilo_precarga.wait_to_finish()
	_hilo_precarga = Thread.new()
	_hilo_precarga.start(func(): _precargar_en_hilo(ruta))

func _precargar_en_hilo(ruta: String):
	var recurso = ResourceLoader.load(ruta)
	if is_instance_of(recurso, PackedScene):
		escena_precargada = recurso
	else:
		push_error("❌ Error: No se pudo precargar la escena o no es una PackedScene: %s" % ruta)


func _on_jugar_pressed() -> void:
	if escena_precargada:
		get_tree().change_scene_to_packed(escena_precargada)
		
func _on_opciones_pressed() -> void:
	var escena_opciones = preload("res://escenas/menu_opciones.tscn").instantiate()
	add_child(escena_opciones)


func _on_salir_pressed() -> void:
	get_tree().quit()
	
func escribir_texto_maquina(texto: String, velocidad: float = 0.2) -> void:
	label_nombre.text = "" 
	audio_maquina.play()  # 🔊 Inicia sonido de máquina
	await mostrar_letra_por_letra(texto, velocidad)
	audio_maquina.stop()  # 🔇 Detiene sonido
	$AnimationPlayer.play("animacionprevia")

func mostrar_letra_por_letra(texto: String, velocidad: float) -> void:
	var texto_actual := ""
	for letra in texto:
		texto_actual += letra
		label_nombre.text = texto_actual
		await get_tree().create_timer(velocidad).timeout
	
func _on_animation_finished(nombre_animacion: String) -> void:
	if nombre_animacion == "animacionprevia":
		animation_player.play("animacionpostpantalladecarga")
		Global.cargar_musica_incio()
