extends Control

var escena_precargada: PackedScene = null
var _hilo_precarga: Thread = null

func _ready() -> void:
	get_tree().paused = false
	precargar_escena("res://escenas/archivos_de_guardado.tscn")
	
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
	pass # Replace with function body.


func _on_salir_pressed() -> void:
	get_tree().quit()
