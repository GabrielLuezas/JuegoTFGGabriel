extends Node

const SAVE_DIR := "user://GuerraEnLaAntartida/"
const SAVE_PATHS := [
	SAVE_DIR + "savegame1.save",
	SAVE_DIR + "savegame2.save",
	SAVE_DIR + "savegame3.save"
]

var current_slot = -1  # Slot actual usado por el jugador

func _ready():
	var dir = DirAccess.open(SAVE_DIR)
	if not dir or not dir.dir_exists(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game(current_slot)  # Guarda automáticamente al cerrar

# Guardar en un archivo específico
func save_game(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		return

	var save_data = {
		"nivel_actual": Global.nivelActual,
		"dinero_acumulado": Global.dineroAcumulado,
		"nivel_maximo": Global.nivelMaximoConseguido,
		"nombre_usuario": Global.nombreUsuario,

		# Mejoras
		"mejora_caña_vieja": Global.mejoraCañaVieja,
		"mejora_caña_buena": Global.mejoraCañaBuena,
		"mejora_super_caña": Global.mejoraSuperCaña,
		"mejora_pinguino_pescador_extra1": Global.mejoraPinguinoPescadorExtra1,
		"mejora_pinguino_pescador_extra2": Global.mejoraPinguinoPescadorExtra2,
		"mejora_pescados_normales_inicio": Global.mejoraPescadosNormalesInicio,
		"mejora_pescados_dorados_inicio": Global.mejoraPescadosDoradosInicio,
		"mejora_anzuelo_dorado": Global.mejoraAnzueloDorado,
		"mejora_sensei_pinguino": Global.mejoraSenseiPinguino,

		# Tutoriales
		"tutorial_nivel_1": Global.tutorialNivel1,
		"tutorial_nivel_2": Global.tutorialNivel2,
		"tutorial_nivel_3": Global.tutorialNivel3,
		"tutorial_nivel_4": Global.tutorialNivel4
	}

	var file = FileAccess.open(SAVE_PATHS[slot], FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

# Cargar desde un archivo específico
func load_game(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		return

	if FileAccess.file_exists(SAVE_PATHS[slot]):
		var file = FileAccess.open(SAVE_PATHS[slot], FileAccess.READ)
		if file:
			var content = file.get_as_text()
			var save_data = JSON.parse_string(content)
			if typeof(save_data) == TYPE_DICTIONARY:
				Global.nivelActual = save_data.get("nivel_actual", 1)
				Global.dineroAcumulado = save_data.get("dinero_acumulado", 0)
				Global.nivelMaximoConseguido = save_data.get("nivel_maximo", 0)
				Global.nombreUsuario = save_data.get("nombre_usuario", "Jugador")

				# Mejoras
				Global.mejoraCañaVieja = save_data.get("mejora_caña_vieja", false)
				Global.mejoraCañaBuena = save_data.get("mejora_caña_buena", false)
				Global.mejoraSuperCaña = save_data.get("mejora_super_caña", false)
				Global.mejoraPinguinoPescadorExtra1 = save_data.get("mejora_pinguino_pescador_extra1", false)
				Global.mejoraPinguinoPescadorExtra2 = save_data.get("mejora_pinguino_pescador_extra2", false)
				Global.mejoraPescadosNormalesInicio = save_data.get("mejora_pescados_normales_inicio", false)
				Global.mejoraPescadosDoradosInicio = save_data.get("mejora_pescados_dorados_inicio", false)
				Global.mejoraAnzueloDorado = save_data.get("mejora_anzuelo_dorado", false)
				Global.mejoraSenseiPinguino = save_data.get("mejora_sensei_pinguino", false)

				# Tutoriales
				Global.tutorialNivel1 = save_data.get("tutorial_nivel_1", false)
				Global.tutorialNivel2 = save_data.get("tutorial_nivel_2", false)
				Global.tutorialNivel3 = save_data.get("tutorial_nivel_3", false)
				Global.tutorialNivel4 = save_data.get("tutorial_nivel_4", false)

				current_slot = slot
			file.close()
	else:
		reset_global_data()
		save_game(slot)

# Eliminar un archivo de guardado
func delete_save(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		return

	if FileAccess.file_exists(SAVE_PATHS[slot]):
		var error = DirAccess.remove_absolute(SAVE_PATHS[slot])
		if error == OK:
			print("🗑️ Archivo de guardado eliminado en slot ", slot)
		else:
			print("❌ Error al eliminar el archivo en slot ", slot, ": ", error)
	else:
		print("ℹ️ No se encontró archivo para eliminar en slot ", slot)

# Restaurar datos por defecto si no hay guardado
func reset_global_data():
	Global.nivelActual = 1
	Global.dineroAcumulado = 0
	Global.nivelMaximoConseguido = 1
	Global.nombreUsuario = "Jugador"

	Global.mejoraCañaVieja = false
	Global.mejoraCañaBuena = false
	Global.mejoraSuperCaña = false
	Global.mejoraPinguinoPescadorExtra1 = false
	Global.mejoraPinguinoPescadorExtra2 = false
	Global.mejoraPescadosNormalesInicio = false
	Global.mejoraPescadosDoradosInicio = false
	Global.mejoraAnzueloDorado = false
	Global.mejoraSenseiPinguino = false

	Global.tutorialNivel1 = false
	Global.tutorialNivel2 = false
	Global.tutorialNivel3 = false
	Global.tutoriNivel4 = false

# Señales para botones
func on_button_cargar_pressed(slot):
	load_game(slot)

func on_button_borrar_pressed(slot):
	delete_save(slot)
