extends Control

# Obtener referencias a las dos capas de flechas
@onready var flechas_a = $Flechas
@onready var flechas_b = $Flechas2

# Variable para alternar entre A y B
var mostrar_a = true

var ruta = "res://escenas/mapa_seleccion_nivel.tscn"

func _ready():
	flechas_b.visible = false  # Al inicio, solo se muestra la capa A
	iniciar_animacion_flechas()

# Esta función crea un temporizador que alterna las capas
func iniciar_animacion_flechas():
	var temporizador = Timer.new()
	temporizador.wait_time = 0.5  # Cambiar cada medio segundo
	temporizador.one_shot = false
	temporizador.autostart = true
	add_child(temporizador)
	temporizador.timeout.connect(_al_cambiar_tiempo)

# Alternar visibilidad entre A y B
func _al_cambiar_tiempo():
	mostrar_a = !mostrar_a
	if mostrar_a:
		flechas_a.show()
		flechas_b.hide()
	else:
		flechas_a.hide()
		flechas_b.show()


func _on_mapa_pressed() -> void:
	Global.comenzar_carga(ruta)
	Global.manejar_musica_por_escena("res://escenas/pantalla_de_carga.tscn")
	Global.rutaImagen1 = "res://img/InteriorCasasImportantes.png"
	Global.rutaImagen2 = "res://img/FotoLibroTransicion.png"
	get_tree().change_scene_to_file("res://escenas/pantalla_de_carga.tscn")


func _on_boton_puerta_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")
