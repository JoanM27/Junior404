extends Interactuable

@export var datos: SupervisorData
var minijuegos: Array[String] = [
	"res://scenes/minigames/hardware/HardwareMinigame.tscn",
	"res://scenes/minigames/terminal/TerminalMinigame.tscn",
    "res://scenes/minigames/wiring/WiringMinigame.tscn"
]
var minijuego_actual: int = 0

enum Fase { IDLE, BIENVENIDA, TAREA }
var fase_actual: Fase = Fase.IDLE

func _ready() -> void:
	super._ready()
	SupervisorManager.cargar_supervisor(datos)
	SupervisorManager.dialogo_terminado.connect(_on_dialogo_terminado)

func interactuar() -> void:
	if fase_actual != Fase.IDLE:
		return
	mostrar_boton_interaccion(false)
	fase_actual = Fase.BIENVENIDA
	SupervisorManager.play_animacion("idle")  # o "talk" si tienes esa animación
	SupervisorManager.iniciar_dialogo("bienvenida")

func _on_dialogo_terminado() -> void:
	match fase_actual:
		Fase.BIENVENIDA:
			fase_actual = Fase.TAREA
			SupervisorManager.play_animacion("idle")
			SupervisorManager.iniciar_dialogo("tarea")
		Fase.TAREA:
			fase_actual = Fase.IDLE
			SupervisorManager.play_animacion("idle_down")
			GameManager.ir_a_minijuego(minijuegos[minijuego_actual % minijuegos.size()])
			minijuego_actual += 1
		Fase.IDLE:
			pass
