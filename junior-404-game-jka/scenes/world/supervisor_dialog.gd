extends CanvasLayer
func _ready() -> void:
	SupervisorManager.dialogo_iniciado.connect(_on_dialogo_iniciado)
	SupervisorManager.dialogo_terminado.connect(hide)

func _on_dialogo_iniciado(texto: String) -> void:
	show()
	$Label.text = texto
	$AnimationPlayer.play("entrar")
	
func _on_supervisor_cambiado(data: SupervisorData) -> void:
	$AnimatedSprite2D.sprite_frames = data.sprite_frames_dialogo
	$AnimatedSprite2D.play("idle")

func _on_reaccion(nombre_anim: String) -> void:
	if $AnimatedSprite2D.sprite_frames.has_animation(nombre_anim):
		$AnimatedSprite2D.play(nombre_anim)
