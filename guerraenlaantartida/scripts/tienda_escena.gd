extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TuDinero2.text = str(Global.dineroAcumulado)
	actualizar_tienda()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boton_caña_vieja_pressed() -> void:
	
	if Global.dineroAcumulado >= 50:
		var confirmacion = await pedir_confirmacion("Caña Vieja" , "Permite que los pingüinos que la lleven equipada reduzcan el intervalo de pesca de 6-8 segundos a 6-7 segundos.", 50, "img/Tienda/MejoraCañaVieja.png")
		if confirmacion:
			Global.dineroAcumulado = Global.dineroAcumulado - 50
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraCañaVieja = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()
	

func _on_boton_caña_buena_pressed() -> void:
	if Global.dineroAcumulado >= 100:
		var confirmacion = await pedir_confirmacion("Caña Buena", "Permite que los pingüinos que la lleven equipada reduzcan el intervalo de pesca de 6-7 segundos a 5-6 segundos.", 100, "img/Tienda/MejoraCañaBuena.png")
		if confirmacion:
			Global.dineroAcumulado -= 100
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraCañaBuena = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_super_caña_pressed() -> void:
	if Global.dineroAcumulado >= 150:
		var confirmacion = await pedir_confirmacion("Super Caña", "Permite que los pingüinos que la lleven equipada reduzcan el intervalo de pesca de 5-6 segundos a 4-5 segundos.", 150, "img/Tienda/MejoraSuperCaña.png")
		if confirmacion:
			Global.dineroAcumulado -= 150
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraSuperCaña = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_pinguino_extra_pressed() -> void:
	if Global.dineroAcumulado >= 100:
		var confirmacion = await pedir_confirmacion("Pinguino Pescador Extra", "Se añade un nuevo pingüino pescador al mapa.", 100, "img/Tienda/MejoraPinguPescador1.png")
		if confirmacion:
			Global.dineroAcumulado -= 100
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraPinguinoPescadorExtra1 = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_pinguino_extra_2_pressed() -> void:
	if Global.dineroAcumulado >= 100:
		var confirmacion = await pedir_confirmacion("Pinguino Pescador Extra 2", "Se añade un nuevo pingüino pescador al mapa.", 100, "img/Tienda/MejoraPinguPescador2.png")
		if confirmacion:
			Global.dineroAcumulado -= 100
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraPinguinoPescadorExtra2 = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_peces_normales_pressed() -> void:
	if Global.dineroAcumulado >= 150:
		var confirmacion = await pedir_confirmacion("Peces normales extra", "Al comenzar cada nivel, el jugador dispone de 5 peces normales.", 150, "img/Tienda/MejoraPescaoNormal.png")
		if confirmacion:
			Global.dineroAcumulado -= 150
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraPescadosNormalesInicio = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_peces_dorados_pressed() -> void:
	if Global.dineroAcumulado >= 150:
		var confirmacion = await pedir_confirmacion("Pez dorado extra", "Al comenzar cada nivel, el jugador dispone de 1 pez doado", 150,"img/Tienda/MejoraPescaoDorado.png")
		if confirmacion:
			Global.dineroAcumulado -= 150
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraPescadosDoradosInicio = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_anzuelo_dorados_pressed() -> void:
	if Global.dineroAcumulado >= 200:
		var confirmacion = await pedir_confirmacion("Anzuelo dorado", "La posibilidad de obtener un pez dorado se incrementa del 10% al 15% para todos los pingüinos pescadores.", 200, "img/Tienda/MejoraAnzueloDorado.png")
		if confirmacion:
			Global.dineroAcumulado -= 200
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraAnzueloDorado = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()


func _on_boton_mejora_sensei_pressed() -> void:
	if Global.dineroAcumulado >= 200:
		var confirmacion = await pedir_confirmacion("Maestro Pinguino", "La primera vez que un enemigo cruce la línea de defensa en cada nivel, aparecerá el maestro sensei para eliminar a todos los enemigos de la línea en la que se encuentre ese enemigo. (Esto no afecta a los jefes).", 200, "img/Tienda/MejoraViejo.png")
		if confirmacion:
			Global.dineroAcumulado -= 200
			$TuDinero2.text = str(Global.dineroAcumulado)
			Global.mejoraAnzueloDorado = true
			aplicarFomatoTextoComprarObjeto()
			actualizar_tienda()
	else:
		aplicarFomatoTextoVendedorSinDinero()

func pedir_confirmacion(texto: String, texto2: String, precio: int, imagen: String) -> bool:
	var confirmacion = preload("res://escenas/interfaz_hacer_compra.tscn").instantiate()
	confirmacion.global_position = $Marker2D.global_position
	add_child(confirmacion)
	confirmacion.get_node("NombreItem").text = texto
	confirmacion.get_node("DescripcionItem").text = texto2
	confirmacion.get_node("Coste").text = str(precio)
	confirmacion.get_node("ImagenMejora").texture = load(imagen)
	var respuesta = await confirmacion.resultado
	if respuesta:
		return true
	else:
		return false

func aplicarFomatoTextoVendedorSinDinero():
	$TextoPinguino.text = "No tienes dinero suficiente para comprar ese objeto"
	$TextoPinguino.add_theme_color_override("font_color", Color.RED)
	await get_tree().create_timer(3.0).timeout
	$TextoPinguino.text = "Esta es mi mercancía"
	$TextoPinguino.add_theme_color_override("font_color", Color.BLACK)
	
func aplicarFomatoTextoComprarObjeto():
	$TextoPinguino.text = "Gracias por tu compra"
	$TextoPinguino.add_theme_color_override("font_color", Color.SEA_GREEN)
	await get_tree().create_timer(3.0).timeout
	$TextoPinguino.text = "Esta es mi mercancía"
	$TextoPinguino.add_theme_color_override("font_color", Color.BLACK)
		
func actualizar_tienda():
	$"BotonCañaVieja".hide()
	$"MejoraCañaVeja".hide()
	$"DineroCañaVieja".hide()
	$"BotonCañaBuena".hide()
	$"MejoraCañaBuena".hide()
	$"DineroCañaBuena".hide()
	$"BotonSuperCaña".hide()
	$"MejoraSuperCaña".hide()
	$"DineroSuperCaña".hide()

# Lógica para mostrar lo siguiente que se puede mejorar
	if !Global.mejoraCañaVieja:
		$"BotonCañaVieja".show()
		$"MejoraCañaVeja".show()
		$"DineroCañaVieja".show()
	elif !Global.mejoraCañaBuena:
		$"BotonCañaBuena".show()
		$"MejoraCañaBuena".show()
		$"DineroCañaBuena".show()
	elif !Global.mejoraSuperCaña:
		$"BotonSuperCaña".show()
		$"MejoraSuperCaña".show()
		$"DineroSuperCaña".show()
		
	if Global.mejoraAnzueloDorado:
		$BotonAnzueloDorados.hide()
		$MejoraAnzueloDorado.hide()
		$DineroMejoraAnzuelo.hide()
	else:
		$BotonAnzueloDorados.show()
		$MejoraAnzueloDorado.show()
		$DineroMejoraAnzuelo.show()
		
	if Global.mejoraPescadosDoradosInicio:
		$BotonPecesDorados.hide()
		$MejoraPescaoDorado.hide()
		$DineroMejoraPecesDoradosExtra.hide()
	else:
		$BotonPecesDorados.show()
		$MejoraPescaoDorado.show()
		$DineroMejoraPecesDoradosExtra.show()
		
	if Global.mejoraPescadosNormalesInicio:
		$BotonPecesNormales.hide()
		$MejoraPescaoNormal.hide()
		$DineroMejoraPecesNormalesExtra.hide()
	else:
		$BotonPecesNormales.show()
		$MejoraPescaoNormal.show()
		$DineroMejoraPecesNormalesExtra.show()
	
	if Global.mejoraPinguinoPescadorExtra1:
		$BotonPinguinoExtra.hide()
		$MejoraPinguPescador1.hide()
		$DineroMejoraPinguinoExtra.hide()
	
	if Global.mejoraPinguinoPescadorExtra2:
		$BotonPinguinoExtra2.hide()
		$MejoraPinguPescador2.hide()
		$DineroMejoraPinguinoExtra2.hide()
	
	if Global.mejoraSenseiPinguino:
		$BotonMejoraSensei.hide()
		$MejoraViejo.hide()
		$DineroMejoraSensei.hide()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/campamento_principal.tscn")
