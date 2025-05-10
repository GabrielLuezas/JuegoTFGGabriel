extends Control

@onready var fondo_negro: ColorRect = $ColorRect
@onready var sprite_pingüino: Sprite2D = $Sprite2D
@onready var texto_cargando: Label = $Label
@onready var animaciones: AnimationPlayer = $AnimationPlayer

var escena_a_mostrar: PackedScene = null
var en_transicion: bool = false
var puntos_cargando: String = "."
var cargando_activo: bool = false

func _ready():
	animaciones.play("fade_out")
	animaciones.animation_finished.connect(_cuando_animacion_termina)
	$EleccionNivelFondo.hide()
	set_process(true)

func _process(delta):
	if not cargando_activo or en_transicion:
		return

	if Global.carga_lista():
		escena_a_mostrar = Global.obtener_escena_cargada()
		if escena_a_mostrar and not en_transicion:
			en_transicion = true
			animaciones.play("fade_in")
			$EleccionNivelFondo.show()
			animaciones.animation_finished.connect(_cuando_se_oculte)
	else:
		# Actualiza el texto "Cargando .", "Cargando ..", "Cargando ..."
		var tiempo_transcurrido = int(floor(Time.get_ticks_msec() / 500)) % 3
		puntos_cargando = ".".repeat(tiempo_transcurrido + 1)
		texto_cargando.text = "Cargando" + puntos_cargando

		# Hacer que el pingüino gire continuamente
		sprite_pingüino.rotation_degrees += 90 * delta

func _cuando_se_oculte(nombre_anim: String):
	if nombre_anim == "fade_in":
		get_tree().change_scene_to_packed(escena_a_mostrar)

func _cuando_animacion_termina(nombre_anim: String):
	if nombre_anim == "fade_out":
		$MapaFondo.hide()
		# Activar rotación del pingüino y texto de carga después del fade_out
		cargando_activo = true
