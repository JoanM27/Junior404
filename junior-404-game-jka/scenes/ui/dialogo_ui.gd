# res://scenes/ui/DialogoUI.gd
extends Control

@onready var retrato: AnimatedSprite2D = $AnimatedSprite2D
@onready var label_nombre: Label = $PanelContainer/VBoxContainer/Label
@onready var label_texto: RichTextLabel = $PanelContainer/VBoxContainer/RichTextLabel
@onready var indicador: TextureRect = $TextureRect
@onready var animacion: AnimationPlayer = $AnimationPlayer

var lineas: Array = []
var linea_actual: int = 0
var escribiendo: bool = false
var velocidad_texto: float = 0.03  # segundos por caracter

func _ready() -> void:
	SupervisorManager.dialogo_iniciado.connect(_on_dialogo_iniciado)
	SupervisorManager.dialogo_terminado.connect(_on_dialogo_terminado)
	hide()

func _on_dialogo_iniciado(nuevas_lineas: Array) -> void:
	lineas = nuevas_lineas
	linea_actual = 0
	var data = SupervisorManager.supervisor_actual
	label_nombre.text = data.nombre
	retrato.sprite_frames = data.sprite_frames_dialogo
	retrato.play("idle")
	show()
	animacion.play("entrar")
	_mostrar_linea()

func _mostrar_linea() -> void:
	if linea_actual >= lineas.size():
		_terminar()
		return
	indicador.hide()
	escribiendo = true
	label_texto.text = ""
	label_texto.visible_ratio = 0.0
	var texto = lineas[linea_actual]
	label_texto.text = texto
	# Efecto typewriter
	var tween = create_tween()
	tween.tween_property(label_texto, "visible_ratio", 1.0,
		texto.length() * velocidad_texto)
	tween.finished.connect(_on_texto_completo)

func _on_texto_completo() -> void:
	escribiendo = false
	indicador.show()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	var avanzo = event.is_action_pressed("interactuar") or \
				 event is InputEventScreenTouch and event.pressed
	if not avanzo:
		return
	if escribiendo:
		# Si presiona mientras escribe, completa el texto al instante
		label_texto.visible_ratio = 1.0
		get_tree().create_timer(0.0).timeout.connect(_on_texto_completo)
	else:
		linea_actual += 1
		_mostrar_linea()

func _terminar() -> void:
	animacion.play("salir")
	await animacion.animation_finished
	hide()
	SupervisorManager.terminar_dialogo()

func _on_dialogo_terminado() -> void:
	pass  # el Supervisor decide qué pasa después
	
