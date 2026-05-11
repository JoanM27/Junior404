extends Node2D
func _ready() -> void:
	SupervisorManager.reaccion_emitida.connect(_on_reaccion)

func _on_reaccion(tipo: String) -> void:
	$AnimationPlayer.play(tipo)  # "exito", "error", "presion"
