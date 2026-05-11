class_name MinigameController
extends Node

signal juego_iniciado
signal accion_validada(correcta: bool)
signal error_cometido
signal juego_finalizado(resultado: Dictionary)

# Config base — cada minijuego puede sobreescribir
@export var tiempo_limite: float = 60.0
@export var recompensa_base: int = 100
@export var penalizacion: int = 50

var tiempo_restante: float = 0.0
var errores_cometidos: int = 0
var _activo: bool = false

func _ready() -> void:
	iniciar_juego()

func _process(delta: float) -> void:
	if not _activo:
		return
	tiempo_restante -= delta
	_on_tick(delta)
	if tiempo_restante <= 0.0:
		finalizar_juego(false)

# --- Ciclo principal ---
func iniciar_juego() -> void:
	tiempo_restante = tiempo_limite + PlayerData.get_bonus_tiempo()
	errores_cometidos = 0
	_activo = true
	emit_signal("juego_iniciado")

func finalizar_juego(completado: bool) -> void:
	_activo = false
	var recompensa = _calcular_recompensa() if completado else 0
	var resultado = {
		"completado": completado,
		"recompensa": recompensa,
		"penalizacion": penalizacion if not completado else 0,
		"errores": errores_cometidos,
		"tiempo_restante": tiempo_restante
	}
	emit_signal("juego_finalizado", resultado)
	GameManager.registrar_resultado(resultado)

func validar_accion(correcta: bool) -> void:
	# Aplica riesgo del item equipado
	if correcta and _falla_por_riesgo():
		correcta = false

	if correcta:
		emit_signal("accion_validada", true)
		_on_accion_correcta()
	else:
		errores_cometidos += 1
		emit_signal("error_cometido")
		emit_signal("accion_validada", false)
		_on_accion_incorrecta()

func _falla_por_riesgo() -> bool:
	return randf() < PlayerData.get_riesgo_fallo()

func _calcular_recompensa() -> int:
	# Bonus por rapidez, penalización por errores
	var bonus_tiempo = int((tiempo_restante / tiempo_limite) * recompensa_base * 0.5)
	var penalidad_errores = errores_cometidos * 15
	return max(recompensa_base + bonus_tiempo - penalidad_errores, 0)

# --- Hooks para los minijuegos hijos ---
# Sobreescribe estos en HardwareController, TerminalController, WiringController
func _on_tick(_delta: float) -> void:
	pass

func _on_accion_correcta() -> void:
	pass

func _on_accion_incorrecta() -> void:
	pass
