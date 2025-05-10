extends Control

const SAVE_DIR := "user://GuerraEnLaAntartida/"
const SAVE_PATHS := [
	SAVE_DIR + "savegame1.save",
	SAVE_DIR + "savegame2.save",
	SAVE_DIR + "savegame3.save"
]
var escena_nombre_usuario = preload("res://escenas/elegir_nombre_usuario.tscn")

var ruta = "res://escenas/campamento_principal.tscn"

func _ready() -> void:
	comprobar_archivos_guardado()


func _process(delta: float) -> void:
	pass


func comprobar_archivos_guardado():
	for i in range(SAVE_PATHS.size()):
		var save_file_path = SAVE_PATHS[i]
		if FileAccess.file_exists(save_file_path):
			var file = FileAccess.open(save_file_path, FileAccess.READ)
			if file:
				var content = file.get_as_text()
				file.close()
				
				var json = JSON.new()
				var result = json.parse(content)
				
				if result == OK and typeof(json.data) == TYPE_DICTIONARY:
					# El archivo existe y tiene datos válidos
					$Botones.get_node("BotonBorrarDatosArchivo%d" % (i + 1)).show()
					$Botones.get_node("BotonCargarDatosArchivo%d" % (i + 1)).show()
					$Botones.get_node("BotonCrearNuevaPartida%d" % (i + 1)).hide()
					$Layers.get_node("MasDetalles%d" % (i + 1)).show()
					$Layers.get_node("Botones%d" % (i + 1)).show()
					$Layers.get_node("BotonEmpezarNuevaPartidaArchivo%d" % (i + 1)).hide()
					$Layers.get_node("DetallesTarjetasIconos%d" % (i + 1)).show()
					$Textos.get_node("CrearNuevaPartida%d" % (i + 1)).hide()
					var nombre = json.data.get("nombre_usuario", "SIN NOMBRE")
					var monedas = json.data.get("dinero_acumulado", "0")
					var nivel = json.data.get("nivel_maximo", "0")
					$Textos.get_node("NombreJugadorArchivo%d" % (i + 1)).text = nombre
					var label_monedas = $Textos.get_node("IndicadorMonedas%d" % (i + 1))
					var label_nivel = $Textos.get_node("IndicadorNivel%d" % (i + 1))
					label_monedas.text += str(monedas)
					label_nivel.text += str(nivel)
					label_nivel.show()
					label_monedas.show()
					continue # pasa al siguiente índice
					
		# Si el archivo no existe o está vacío/corrupto, se ejecuta este bloque
		$Botones.get_node("BotonBorrarDatosArchivo%d" % (i + 1)).hide()
		$Botones.get_node("BotonCargarDatosArchivo%d" % (i + 1)).hide()
		$Botones.get_node("BotonCrearNuevaPartida%d" % (i + 1)).show()
		$Layers.get_node("MasDetalles%d" % (i + 1)).hide()
		$Layers.get_node("Botones%d" % (i + 1)).hide()
		$Layers.get_node("BotonEmpezarNuevaPartidaArchivo%d" % (i + 1)).show()
		$Layers.get_node("DetallesTarjetasIconos%d" % (i + 1)).hide()
		$Textos.get_node("CrearNuevaPartida%d" % (i + 1)).show()
		$Textos.get_node("NombreJugadorArchivo%d" % (i + 1)).hide()
		$Textos.get_node("IndicadorMonedas%d" % (i + 1)).hide()
		$Textos.get_node("IndicadorNivel%d" % (i + 1)).hide()
		$Layers.get_node("DetallesCaracteristicasUsuario%d" % (i + 1)).hide()


func _on_boton_cargar_datos_archivo_1_pressed() -> void:
	Guardado.current_slot = 0
	Guardado.load_game(0)
	cargarMapa()

func _on_boton_cargar_datos_archivo_2_pressed() -> void:
	Guardado.current_slot = 1
	Guardado.load_game(1)
	cargarMapa()

func _on_boton_cargar_datos_archivo_3_pressed() -> void:
	Guardado.current_slot = 2
	Guardado.load_game(2)
	cargarMapa()

func cargarMapa():
	get_tree().change_scene_to_file(ruta)

func _on_boton_borrar_datos_archivo_1_pressed() -> void:
	var confirmacion = await pedir_confirmacion("¿Estás seguro que deseas borrar la partida?")
	if confirmacion:
		Guardado.delete_save(0)
		comprobar_archivos_guardado()


func _on_boton_borrar_datos_archivo_2_pressed() -> void:
	var confirmacion = await pedir_confirmacion("¿Estás seguro que deseas borrar la partida?")
	if confirmacion:
		Guardado.delete_save(1)
		comprobar_archivos_guardado()


func _on_boton_borrar_datos_archivo_3_pressed() -> void:
	var confirmacion = await pedir_confirmacion("¿Estás seguro que deseas borrar la partida?")
	if confirmacion:
		Guardado.delete_save(2)
		comprobar_archivos_guardado()


func _on_boton_crear_nueva_partida_1_pressed() -> void:
	Guardado.current_slot = 0
	mostrar_escena_nombre()


func _on_boton_crear_nueva_partida_2_pressed() -> void:
	Guardado.current_slot = 1
	mostrar_escena_nombre()


func _on_boton_crear_nueva_partida_3_pressed() -> void:
	Guardado.current_slot = 2
	mostrar_escena_nombre()


func mostrar_escena_nombre():
	var instancia = escena_nombre_usuario.instantiate()
	
	get_parent().add_child(instancia)
	instancia.global_position = $Marker2D.global_position
	
func pedir_confirmacion(texto: String) -> bool:
	var confirmacion = preload("res://escenas/confirmar_accion.tscn").instantiate()
	confirmacion.global_position = $Marker2D.global_position
	add_child(confirmacion)
	confirmacion.get_node("Label").text = texto
	var respuesta = await confirmacion.resultado
	if respuesta:
		return true
	else:
		return false
