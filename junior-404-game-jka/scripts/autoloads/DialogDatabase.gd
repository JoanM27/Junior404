# res://scripts/autoloads/DialogDatabase.gd
extends Node

# Estructura: { "NombreSupervisor": { "situacion": ["linea1", "linea2"] } }
const DIALOGOS: Dictionary = {
	"Isabella": {
		"bienvenida":  ["Llegas tarde. Otra vez.", "Espero que hoy no la riegues."],
		"tarea":       ["Tienes 60 segundos. No me decepciones."],
		"exito":       ["Hmm. Bien hecho.", "No esperaba menos... bueno, sí esperaba menos."],
		"error":       ["¿En serio?", "Eso fue un desastre."],
		"presion":     ["VAS A HACER QUE ME DÉ UN INFARTO."]
	},
	"Carlos": {
		"bienvenida":  ["¡Ey! Tranquilo, hoy va a estar fácil."],
		"tarea":       ["Tómatelo con calma, tú puedes."],
		"exito":       ["¡Eso es! ¡Crack!"],
		"error":       ["Ah... bueno, la próxima."],
		"presion":     ["Oye, respira. Aún puedes recuperarte."]
	}
	# Agrega más supervisores aquí
}

func get_linea(supervisor: String, situacion: String) -> String:
	if DIALOGOS.has(supervisor) and DIALOGOS[supervisor].has(situacion):
		var lineas = DIALOGOS[supervisor][situacion]
		return lineas[randi() % lineas.size()]
	return "..."

func get_lineas(supervisor: String, situacion: String) -> Array:
	if DIALOGOS.has(supervisor) and DIALOGOS[supervisor].has(situacion):
		return DIALOGOS[supervisor][situacion]
	return ["..."] 
