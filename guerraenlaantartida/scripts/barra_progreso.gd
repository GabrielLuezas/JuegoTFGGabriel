extends Node2D

@onready var barra_progreso = $BarraProgreso
@onready var icono_progreso = $IconoProgreso

@export var duracion_total := 0  # Duración total del nivel en segundos
var tiempo_actual := 0.0
var progreso_objetivo := 0.0
var nivel_iniciado := false  # <- NUEVA VARIABLE

func _ready():
	barra_progreso.min_value = 0
	barra_progreso.max_value = duracion_total
	barra_progreso.value = 0

func _process(delta):
	if !nivel_iniciado:
		return  # ← Solo actualiza si el nivel ha comenzado

	if tiempo_actual < duracion_total:
		tiempo_actual += delta
		progreso_objetivo = clamp(tiempo_actual, 0, duracion_total)
		barra_progreso.value = lerp(barra_progreso.value, progreso_objetivo, 5 * delta)
		_actualizar_posicion_icono()
	else:
		barra_progreso.value = duracion_total
		_actualizar_posicion_icono()

func _actualizar_posicion_icono():
	var barra_pos = barra_progreso.global_position
	var barra_ancho = barra_progreso.size.x
	var progreso = barra_progreso.value / duracion_total
	icono_progreso.global_position.x = barra_pos.x + barra_ancho * (1.0 - progreso)
	icono_progreso.global_position.y = barra_pos.y - -12
	
func _actualizar_tiempo(tiempo: int) -> void:
	duracion_total = tiempo
	barra_progreso.max_value = tiempo

func iniciar_nivel():  # ← MÉTODO NUEVO
	nivel_iniciado = true
	tiempo_actual = 0.0
	barra_progreso.value = 0
