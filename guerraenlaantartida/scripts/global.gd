extends Node

var ubicacion = Vector2(0, 0)
var comprobacion = false
var modo_compra = false

var peces = 0
var pecesDorados = 0
var nivelActual = 0
var dineroAcumulado = 0.00
var nombreUsuario = ""
var nivelMaximoConseguido = 0

var ruta_escena_siguiente: String = ""
var escena_precargada: PackedScene = null
var _hilo_carga: Thread = null
var _carga_completa: bool = false

var pinguino_seleccionado_aura_amarilla : Node = null

func gastar_peces(cantidad: int) -> bool:
	if peces >= cantidad:
		peces -= cantidad
		return true
	else:
		return false


func comenzar_carga(ruta: String):
	ruta_escena_siguiente = ruta
	escena_precargada = null
	_carga_completa = false
	if _hilo_carga and _hilo_carga.is_alive():
		_hilo_carga.wait_to_finish()
	_hilo_carga = Thread.new()
	_hilo_carga.start( func(): _cargar_escena_en_hilo(ruta) )
	
func _cargar_escena_en_hilo(ruta: String):
	var recurso = ResourceLoader.load(ruta)
	if recurso and recurso is PackedScene:
		escena_precargada = recurso
		_carga_completa = true
	else:
		push_error("Error al cargar la escena: %s" % ruta)

# Verifica si la escena ya está cargada
func carga_lista() -> bool:
	return _carga_completa

# Devuelve la escena precargada
func obtener_escena_cargada() -> PackedScene:
	return escena_precargada
