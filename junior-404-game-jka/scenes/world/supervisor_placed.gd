# res://scripts/world/Supervisor.gd
extends Interactuable

@export var datos: SupervisorData  # aquí arrastras Isabella.tres desde el inspector
var minijuegos: Array[String] = [
	"res://scenes/minigames/hardware/HardwareMinigame.tscn",
	"res://scenes/minigames/terminal/TerminalMinigame.tscn",
    "res://scenes/minigames/wiring/WiringMinigame.tscn"
]
var minijuego_actual: int = 0
func _ready() -> void:
	SupervisorManager.cargar_supervisor(datos)
	$AnimatedSprite2D.sprite_frames = datos.sprite_frames_mundo
	$AnimatedSprite2D.play("Isabella_idle_down")
	SupervisorManager.dialogo_terminado.connect(_on_dialogo_terminado)

func interactuar() -> void:
	mostrar_boton_interaccion(false)
	SupervisorManager.iniciar_dialogo("bienvenida")

func _on_dialogo_terminado() -> void:
	SupervisorManager.iniciar_dialogo("tarea")
	# Espera que termine el diálogo de tarea también
	await SupervisorManager.dialogo_terminado
	GameManager.ir_a_minijuego(minijuegos[minijuego_actual % minijuegos.size()])
	minijuego_actual += 1

func _on_supervisor_cambiado(data: SupervisorData) -> void:
	$AnimatedSprite2D.sprite_frames = data.sprite_frames_mundo
	$AnimatedSprite2D.play("idle_down")
