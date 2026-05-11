# res://scripts/player/PlayerController.gd
class_name PlayerController
extends CharacterBody2D

const VELOCIDAD = 120.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_interaccion: Area2D = $AreaInteraccion

var input_joystick: Vector2 = Vector2.ZERO  # lo llena el VirtualJoystick
var objeto_cercano = null  # el interactuable más cercano
var _ultima_direccion: String = "down"

func _physics_process(_delta: float) -> void:
	var direccion = _obtener_direccion()
	velocity = direccion * VELOCIDAD
	move_and_slide()
	_actualizar_animacion(direccion)

func _obtener_direccion() -> Vector2:
	# PC
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Móvil (el joystick escribe aquí)
	if dir == Vector2.ZERO:
		dir = input_joystick
	return dir

func _actualizar_animacion(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		match _ultima_direccion:
			"right": sprite.play("Idle_right")
			"left":  sprite.play("Idle_left")
			"up":    sprite.play("Idle_up")
			"down":       sprite.play("Idle_down")
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			_ultima_direccion = "right"
			sprite.play("Walk_right")
		else:
			_ultima_direccion = "left"
			sprite.play("Walk_left")
	else:
		if dir.y < 0:
			_ultima_direccion = "up"
			sprite.play("Walk_up")
		else:
			_ultima_direccion = "down"
			sprite.play("Walk_down")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interactuar") and objeto_cercano:
		objeto_cercano.interactuar()

# Lo llama el Area2D del jugador
func _on_area_interaccion_body_entered(body: Node) -> void:
	if body.has_method("interactuar"):
		objeto_cercano = body
		body.mostrar_boton_interaccion(true)

func _on_area_interaccion_body_exited(body: Node) -> void:
	if body == objeto_cercano:
		objeto_cercano.mostrar_boton_interaccion(false)
		objeto_cercano = null
