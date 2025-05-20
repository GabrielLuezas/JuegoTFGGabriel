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
var mejoraCañaVieja = false
var mejoraCañaBuena = false
var mejoraSuperCaña = false
var mejoraPinguinoPescadorExtra1 = false
var mejoraPinguinoPescadorExtra2 = false
var mejoraPescadosNormalesInicio = false
var mejoraPescadosDoradosInicio = false
var mejoraAnzueloDorado = false
var cargasSensei = 0
var mejoraSenseiPinguino = false

var tutorialNivel1 = false
var tutorialNivel2 = false
var tutorialNivel3 = false
var tutorialNivel4 = false

var explicarCampamento = false



var ruta_escena_siguiente: String = ""
var escena_precargada: PackedScene = null
var _hilo_carga: Thread = null
var _carga_completa: bool = false

var pinguino_seleccionado_aura_amarilla : Node = null

var rutaImagen1 = null
var rutaImagen2 = null

var musica_player: AudioStreamPlayer = null

var musica_inicio: AudioStreamPlayer


func cargar_musica_incio():
	if musica_inicio == null:
		musica_inicio = AudioStreamPlayer.new()
		musica_inicio.stream = load("res://sonidos/musicas/704399__tomentum__epic-movie-ending-bbc-symphony.ogg")
		musica_inicio.bus = "Music"  # Opcional, si usas buses
		musica_inicio.volume_db = -6
		get_tree().root.add_child(musica_inicio)
		musica_inicio.play()
	elif not musica_inicio.playing:
		musica_inicio.play()

var escenas_con_musica := [
	"res://escenas/campamento_principal.tscn",
	"res://escenas/interior_casa_jefe.tscn",
	"res://escenas/interior_casa_normal.tscn"
]

func reproducir_musica(ruta: String):
	if musica_player == null:
		musica_player = AudioStreamPlayer.new()
		musica_player.stream = load(ruta)
		musica_player.bus = "Music"  # Opcional, si usas buses
		musica_player.volume_db = -6
		get_tree().root.add_child(musica_player)
		musica_player.play()
	elif not musica_player.playing:
		musica_player.play()


func manejar_musica_por_escena(ruta_escena: String):
	if musica_player == null:
		return

	if ruta_escena in escenas_con_musica:
		if not musica_player.playing:
			musica_player.play()
	else:
		musica_player.stop()

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
