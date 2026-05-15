extends AnimatedSprite2D

func _ready() -> void:
	SupervisorManager.supervisor_cambiado.connect(_on_supervisor_cambiado)
	SupervisorManager.reaccion_emitida.connect(_on_reaccion)

func _on_supervisor_cambiado(data: SupervisorData) -> void:
	if data == null:
		return
	sprite_frames = data.sprite_frames_dialogo
	play("idle")

func _on_reaccion(nombre_anim: String) -> void:
	if sprite_frames and sprite_frames.has_animation(nombre_anim):
		play(nombre_anim)
