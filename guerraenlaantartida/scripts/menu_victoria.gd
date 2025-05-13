extends Control

@export var final_amount: int = 50
@export var duration: float = 4.0  # Duración de la animación en segundos

var current_amount: float = 0
var label: Label
var tween: Tween
var ruta = "res://escenas/nivel.tscn"

func _ready():
	label = $Dinero  # Asegúrate de que la ruta sea correcta

func animar_dinero():
	current_amount = 0  # Reiniciar contador por si se llama más de una vez
	tween = create_tween()
	tween.tween_property(self, "current_amount", final_amount, duration)
	tween.play()

func _process(delta):
	label.text = str(round(current_amount))

func _on_siguiente_nivel_pressed() -> void:
	Global.dineroAcumulado = Global.dineroAcumulado + final_amount
	Engine.time_scale = 1.0
	Global.comenzar_carga(ruta)
	get_tree().change_scene_to_file("res://escenas/pantalla_de_carga.tscn")

func _on_campamento_principal_pressed() -> void:
	Global.dineroAcumulado = Global.dineroAcumulado + final_amount
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")
