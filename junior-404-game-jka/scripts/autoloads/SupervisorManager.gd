# res://scripts/autoloads/SupervisorManager.gd
extends Node

signal dialogo_iniciado(texto: String)
signal dialogo_terminado
signal reaccion_emitida(tipo: String)  # "exito", "error", "presion"

var humor_actual: String = "neutral"  # "neutral", "enojado", "contento"
var presion_acumulada: int = 0

# --- Diálogo ---
func iniciar_dialogo(texto: String) -> void:
	emit_signal("dialogo_iniciado", texto)

func terminar_dialogo() -> void:
	emit_signal("dialogo_terminado")

# --- Reacciones (las llama MinigameController) ---
func reaccionar_exito() -> void:
	presion_acumulada = max(0, presion_acumulada - 1)
	humor_actual = "contento"
	emit_signal("reaccion_emitida", "exito")

func reaccionar_error() -> void:
	presion_acumulada += 1
	if presion_acumulada >= 3:
		humor_actual = "enojado"
		emit_signal("reaccion_emitida", "presion")
	else:
		emit_signal("reaccion_emitida", "error")
