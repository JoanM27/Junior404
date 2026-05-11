# res://scripts/autoloads/SupervisorManager.gd
extends Node

signal supervisor_cambiado(data: SupervisorData)
signal dialogo_iniciado(lineas: Array)
signal dialogo_terminado
signal reaccion_emitida(tipo: String)

var supervisor_actual: SupervisorData = null
var humor_actual: String = "neutral"
var presion_acumulada: int = 0

# Reputación: { "Isabella": 5, "Carlos": 3 }  guardada en PlayerData
func get_reputacion(nombre: String) -> int:
	return PlayerData.reputacion.get(nombre, 1)

func sumar_reputacion(nombre: String, puntos: int) -> void:
	var actual = get_reputacion(nombre)
	PlayerData.reputacion[nombre] = clamp(actual + puntos, 1, 10)

# --- Cargar supervisor ---
func cargar_supervisor(data: SupervisorData) -> void:
	supervisor_actual = data
	humor_actual = "neutral"
	presion_acumulada = 0
	emit_signal("supervisor_cambiado", data)

# --- Animaciones ---
# Construye el nombre: accion + "_" + extra  (ej: "idle_down", "angry")
func play_animacion(accion: String, extra: String = "") -> void:
	var nombre_anim: String
	if extra == "":
		nombre_anim = supervisor_actual.nombre + "_" + accion
	else:
		nombre_anim = supervisor_actual.nombre + "_" + accion + "_" + extra
	emit_signal("reaccion_emitida", nombre_anim)

# --- Diálogo ---
func iniciar_dialogo(situacion: String) -> void:
	if supervisor_actual == null:
		return
	var lineas = DialogDatabase.get_lineas(supervisor_actual.nombre, situacion)
	emit_signal("dialogo_iniciado", lineas)

func terminar_dialogo() -> void:
	emit_signal("dialogo_terminado")

# --- Reacciones desde minijuego ---
func reaccionar_exito() -> void:
	presion_acumulada = max(0, presion_acumulada - 1)
	humor_actual = "contento"
	sumar_reputacion(supervisor_actual.nombre, 1)
	play_animacion("happy")
	iniciar_dialogo("exito")

func reaccionar_error() -> void:
	presion_acumulada += 1
	sumar_reputacion(supervisor_actual.nombre, -1)
	if presion_acumulada >= 3:
		humor_actual = "enojado"
		play_animacion("angry")
		iniciar_dialogo("presion")
	else:
		play_animacion("error")
		iniciar_dialogo("error")
