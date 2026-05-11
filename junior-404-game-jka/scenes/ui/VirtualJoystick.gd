# res://scenes/ui/VirtualJoystick.gd
extends Control

@onready var base: TextureRect = $Base
@onready var palanca: TextureRect = $Palanca

var player: PlayerController = null
var radio: float = 50.0
var touch_index: int = -1
var centro: Vector2 = Vector2.ZERO

func _ready() -> void:
	centro = base.position + base.size / 2
	# Busca al jugador en escena
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			if base.get_global_rect().has_point(event.position):
				touch_index = event.index
		elif not event.pressed and event.index == touch_index:
			touch_index = -1
			palanca.position = base.size / 2 - palanca.size / 2
			if player:
				player.input_joystick = Vector2.ZERO

	elif event is InputEventScreenDrag and event.index == touch_index:
		var offset = event.position - base.global_position - base.size / 2
		offset = offset.limit_length(radio)
		palanca.position = base.size / 2 - palanca.size / 2 + offset
		if player:
			player.input_joystick = offset / radio

func _process(_delta: float) -> void:
	# Oculta el joystick en PC
	visible = DisplayServer.is_touchscreen_available()
