extends Control

@onready var slider_volumen: HSlider = $HSlider
@onready var label_valor: Label = $LabelMusica
@onready var boton_guardar: Button = $BotonGuardar

func _ready():
	slider_volumen.value_changed.connect(_on_slider_volumen_changed)
	boton_guardar.pressed.connect(_on_boton_guardar_pressed)

	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err == OK:
		var valor_guardado = config.get_value("audio", "volumen_musica", 100)
		slider_volumen.value = valor_guardado
		_update_volume(valor_guardado)
	else:
		slider_volumen.value = 100
		_update_volume(100)

func _on_slider_volumen_changed(value: float) -> void:
	_update_volume(value)

func _update_volume(value: float) -> void:
	label_valor.text = str(round(value)) + "%"
	var db = linear_to_db(value / 100.0)
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, db)

func _on_boton_guardar_pressed() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "volumen_musica", slider_volumen.value)
	config.save("user://config.cfg")


func _on_boton_salir_pressed() -> void:
	queue_free()
