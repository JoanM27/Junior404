extends Node

signal jornada_iniciada
signal jornada_terminada(resumen: Dictionary)
signal minijuego_terminado(resultado: Dictionary)

# Rutas de escenas
const ESCENA_CASA     = "res://scenes/world/Casa.tscn"
const ESCENA_OFICINA  = "res://scenes/world/Oficina.tscn"
const ESCENA_TRANSICION = "res://scenes/ui/Transicion.tscn"

# Estado de la jornada
var tareas_completadas: int = 0
var tareas_falladas: int = 0
var ganancias_sesion: int = 0

# --- Navegación ---
func ir_a_casa() -> void:
	_cambiar_escena(ESCENA_CASA)

func ir_a_oficina() -> void:
	_cambiar_escena(ESCENA_OFICINA)
	emit_signal("jornada_iniciada")

func ir_a_minijuego(ruta_escena: String) -> void:
	_cambiar_escena(ruta_escena)

func _cambiar_escena(ruta: String) -> void:
	# Aquí después puedes agregar una transición animada
	get_tree().change_scene_to_file(ruta)

# --- Resultados de minijuego ---
func registrar_resultado(resultado: Dictionary) -> void:
	# resultado = { "completado": bool, "recompensa": int, "errores": int }
	if resultado["completado"]:
		tareas_completadas += 1
		ganancias_sesion += resultado["recompensa"]
		PlayerData.añadir_dinero(resultado["recompensa"])
	else:
		tareas_falladas += 1
		PlayerData.descontar_dinero(resultado.get("penalizacion", 0))
	
	emit_signal("minijuego_terminado", resultado)

# --- Fin de jornada ---
func terminar_jornada() -> void:
	var resumen = {
		"completadas": tareas_completadas,
		"falladas": tareas_falladas,
		"ganancias": ganancias_sesion
	}
	_resetear_sesion()
	PlayerData.guardar_progreso()
	emit_signal("jornada_terminada", resumen)
	ir_a_casa()

func _resetear_sesion() -> void:
	tareas_completadas = 0
	tareas_falladas = 0
	ganancias_sesion = 0
