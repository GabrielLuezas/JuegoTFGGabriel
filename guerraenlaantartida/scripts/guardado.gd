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
		print("📁 Carpeta de guardado creada: ", SAVE_DIR)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game(current_slot)  # Guarda automáticamente en el slot actual al cerrar.

# Guardar en un archivo específico
func save_game(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		print("❌ Slot inválido para guardar.")
		return

	var save_data = {
		"nivel_actual": Global.nivelActual,
		"dinero_acumulado": Global.dineroAcumulado,
		"nivel_maximo": Global.nivelMaximoConseguido,
		"nombre_usuario": Global.nombreUsuario
	}

	var file = FileAccess.open(SAVE_PATHS[slot], FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("💾 Juego guardado en ", SAVE_PATHS[slot])
	else:
		print("❌ Error al guardar el archivo en slot ", slot)

# Cargar desde un archivo específico
func load_game(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		print("❌ Slot inválido para cargar.")
		return

	if FileAccess.file_exists(SAVE_PATHS[slot]):
		var file = FileAccess.open(SAVE_PATHS[slot], FileAccess.READ)
		if file:
			var content = file.get_as_text()
			var save_data = JSON.parse_string(content)
			if typeof(save_data) == TYPE_DICTIONARY:
				Global.nivelActual = save_data.get("nivel_actual", 1)
				Global.dineroAcumulado = save_data.get("dinero_acumulado", 0)
				Global.nivelMaximoConseguido = save_data.get("nivel_maximo", 1)
				Global.nombreUsuario = save_data.get("nombre_usuario", "Jugador")
				print("✅ Juego cargado desde slot ", slot, ": Nivel =", Global.nivelActual, "Monedas =", Global.dineroAcumulado, "Nivel Máximo =", Global.nivelMaximoConseguido, "Usuario =", Global.nombreUsuario)
				current_slot = slot  # Actualiza el slot actual
			file.close()
	else:
		print("ℹ️ No se encontró archivo de guardado en slot ", slot, ". Creando uno nuevo...")
		Global.nivelActual = 1
		Global.dineroAcumulado = 0
		Global.nivelMaximoConseguido = 1
		Global.nombreUsuario = "Jugador"
		save_game(slot)

# Eliminar un archivo de guardado
func delete_save(slot):
	if slot < 0 or slot >= SAVE_PATHS.size():
		print("❌ Slot inválido para borrar.")
		return

	if FileAccess.file_exists(SAVE_PATHS[slot]):
		var error = DirAccess.remove_absolute(SAVE_PATHS[slot])
		if error == OK:
			print("🗑️ Archivo de guardado eliminado en slot ", slot)
		else:
			print("❌ Error al eliminar el archivo en slot ", slot, ": ", error)
	else:
		print("ℹ️ No se encontró archivo para eliminar en slot ", slot)

# Señales para botones
func on_button_cargar_pressed(slot):
	load_game(slot)

func on_button_borrar_pressed(slot):
	delete_save(slot)
