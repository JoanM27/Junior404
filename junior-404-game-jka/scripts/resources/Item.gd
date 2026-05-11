class_name Item
extends Resource

@export var nombre: String = ""
@export var descripcion: String = ""
@export var tipo_herramienta: String = ""  # "hardware", "terminal", "wiring", "general"
@export var riesgo_fallo: float = 0.0      # 0.0 = sin riesgo, 1.0 = fallo seguro
@export var bonificador_tiempo: float = 0.0 # segundos extra que da al temporizador
@export var precio: int = 0
@export var icono: Texture2D              # para cuando hagas la tienda
