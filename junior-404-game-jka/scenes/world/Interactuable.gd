# res://scripts/world/Interactuable.gd
class_name Interactuable
extends StaticBody2D

@onready var boton_ui: Button = $BotonInteractuar  # posicionado encima del objeto

func _ready() -> void:
	boton_ui.visible = false
	boton_ui.pressed.connect(interactuar)  # para móvil

func mostrar_boton_interaccion(mostrar: bool) -> void:
	boton_ui.visible = mostrar

func interactuar() -> void:
	pass  # cada objeto sobreescribe esto
