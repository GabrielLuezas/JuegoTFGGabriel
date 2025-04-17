extends Node

var ubicacion = Vector2(0, 0)
var comprobacion = false
var modo_compra = false

# 🐟 Sistema de peces
var peces = 40

func gastar_peces(cantidad: int) -> bool:
	if peces >= cantidad:
		peces -= cantidad
		return true
	else:
		return false
