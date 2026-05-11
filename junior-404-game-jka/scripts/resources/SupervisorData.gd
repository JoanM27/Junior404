# res://scripts/resources/SupervisorData.gd
class_name SupervisorData
extends Resource

@export var nombre: String = ""

# Assets de cada representación
@export var sprite_frames_mundo: SpriteFrames      # top-down oficina
@export var sprite_frames_dialogo: SpriteFrames    # retrato diálogo
@export var sprite_frames_minijuego: SpriteFrames  # animado en minijuego

# Dialogos propios (sobreescriben los genéricos si existen)
@export var dialogos_custom: Dictionary = {}
