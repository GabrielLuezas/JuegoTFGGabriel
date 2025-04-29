extends Node

var ubicacion = Vector2(0, 0)
var comprobacion = false
var modo_compra = false

var peces = 40
var pecesDorados = 5

func gastar_peces(cantidad: int) -> bool:
	if peces >= cantidad:
		peces -= cantidad
		return true
	else:
		return false
