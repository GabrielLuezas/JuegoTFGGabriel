extends Control

var full_text := "Hace muchos, muchos años, pingüinos y focas vivían juntos en armonía."
var type_speed := 0.08
var paso_actual = 1
var siguiente_animacion = ""
var next_scene_path := "res://escenas/nivel.tscn"
var next_scene_resource: PackedScene

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_path)
	$DialogoBlanco.text=""
	$DialogoNegro.text=""
	
	$AnimationPlayer.play("empezarAnimacion")

func _process(delta: float) -> void:
	pass


func show_text_slowly(text: String) -> void:
	await _reveal_text(text)
	await get_tree().create_timer(8.0).timeout
	$DialogoBlanco.text=""
	$DialogoNegro.text=""
	$AnimationPlayer.play(siguiente_animacion)

func _reveal_text(text: String) -> void:
	text = text.strip_edges()
	var current := ""
	for i in text.length():
		current += text[i]
		$DialogoBlanco.text = current
		$DialogoNegro.text = current
		await get_tree().create_timer(type_speed).timeout


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "empezarAnimacion":
		show_text_slowly(full_text)
		siguiente_animacion = "empezarescena2"
	if anim_name == "empezarescena2":
		$Escena2/FocaBoss.play("default")
		full_text = "Pero de repente, debido a unas épocas difíciles, el líder de las focas atacó a un pingüino para alimentarse."
		show_text_slowly(full_text)
		siguiente_animacion = "empezarescena3"
	if anim_name == "empezarescena3":
		full_text = "Desde entonces, focas y pingüinos han estado en guerra. Ahora, tú eres el nuevo estratega encargado de defender a los pingüinos."
		show_text_slowly(full_text)
		siguiente_animacion = "terminar"
	if anim_name == "terminar":
		var status := ResourceLoader.load_threaded_get_status(next_scene_path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			next_scene_resource = ResourceLoader.load_threaded_get(next_scene_path)
			Global.nivelActual = 1
			Global.musica_inicio.stop()
			get_tree().change_scene_to_packed(next_scene_resource)
	
