extends Control

@onready var fondo_negro: ColorRect = $ColorRect
@onready var sprite_pingüino: Sprite2D = $Sprite2D
@onready var texto_cargando: Label = $Label
@onready var animaciones: AnimationPlayer = $AnimationPlayer
@onready var audio_carga: AudioStreamPlayer2D = $AudioStreamPlayer2D

var escena_a_mostrar: PackedScene = null
var en_transicion: bool = false
var puntos_cargando: String = "."
var cargando_activo: bool = false

var tiempo_total_carga: float = 0.0
var tiempo_minimo_carga: float = 10.0  # Ahora dura 10 segundos

var fade_in_hecho: bool = false
var fade_out_hecho: bool = false

func _ready():
	$MapaFondo.texture = load(Global.rutaImagen1)
	$EleccionNivelFondo.texture = load(Global.rutaImagen2)
	animaciones.play("fade_out")
	animaciones.animation_finished.connect(_cuando_animacion_termina)
	$EleccionNivelFondo.hide()
	set_process(true)

	# 🔇 Inicia sonido con volumen bajo
	audio_carga.volume_db = -40
	audio_carga.play()

	# 🎚 Fade-in de volumen (0 a 2 seg)
	var fade_in = get_tree().create_tween()
	fade_in.tween_property(audio_carga, "volume_db", 0, 2.0)

func _process(delta):
	if not cargando_activo or en_transicion:
		return

	tiempo_total_carga += delta

	# 🎚 Fade-out (del segundo 8 al 10)
	if tiempo_total_carga >= 8.0 and not fade_out_hecho:
		fade_out_hecho = true
		var fade_out = get_tree().create_tween()
		fade_out.tween_property(audio_carga, "volume_db", -40, 2.0)

	# Solo cambia de escena si ha pasado el tiempo mínimo
	if Global.carga_lista() and tiempo_total_carga >= tiempo_minimo_carga:
		escena_a_mostrar = Global.obtener_escena_cargada()
		if escena_a_mostrar and not en_transicion:
			en_transicion = true
			animaciones.play("fade_in")
			$EleccionNivelFondo.show()
			animaciones.animation_finished.connect(_cuando_se_oculte)
	else:
		# Texto animado
		var tiempo_transcurrido = int(floor(Time.get_ticks_msec() / 500)) % 3
		puntos_cargando = ".".repeat(tiempo_transcurrido + 1)
		texto_cargando.text = "Cargando" + puntos_cargando

		sprite_pingüino.rotation_degrees += 90 * delta

func _cuando_se_oculte(nombre_anim: String):
	if nombre_anim == "fade_in":
		get_tree().change_scene_to_packed(escena_a_mostrar)

func _cuando_animacion_termina(nombre_anim: String):
	if nombre_anim == "fade_out":
		$MapaFondo.hide()
		cargando_activo = true
