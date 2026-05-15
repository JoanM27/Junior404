extends CanvasLayer

@onready var label_nombre: Label = $Control/Panel/VBoxContainer/Label
@onready var label_texto: RichTextLabel = $Control/Panel/VBoxContainer/Label/RichTextLabel

var lineas: Array = []
var linea_actual: int = 0

func _ready() -> void:
	SupervisorManager.dialogo_iniciado.connect(_on_dialogo_iniciado)
	SupervisorManager.dialogo_terminado.connect(hide)
	hide()

func _on_dialogo_iniciado(nuevas_lineas: Array) -> void:
	lineas = nuevas_lineas
	linea_actual = 0
	label_nombre.text = SupervisorManager.supervisor_actual.nombre
	show()
	_mostrar_linea()

func _mostrar_linea() -> void:
	if linea_actual >= lineas.size():
		hide()
		SupervisorManager.terminar_dialogo()
		return
	label_texto.text = lineas[linea_actual]

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interactuar"):
		linea_actual += 1
		_mostrar_linea()
		
func _on_supervisor_cambiado(data: SupervisorData) -> void:
	$AnimatedSprite2D.sprite_frames = data.sprite_frames_dialogo
	$AnimatedSprite2D.play("idle")

func _on_reaccion(nombre_anim: String) -> void:
	if $AnimatedSprite2D.sprite_frames.has_animation(nombre_anim):
		$AnimatedSprite2D.play(nombre_anim)
