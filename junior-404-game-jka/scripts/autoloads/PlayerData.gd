extends Node

signal dinero_cambiado(nuevo_valor: int)
signal item_equipado_cambiado(item: Item)

var dinero: int = 500
var inventario_items: Array[Item] = []
var item_equipado: Item = null

# --- Economía ---
func añadir_dinero(monto: int) -> void:
	dinero += monto
	emit_signal("dinero_cambiado", dinero)

func descontar_dinero(monto: int) -> bool:
	if dinero >= monto:
		dinero -= monto
		emit_signal("dinero_cambiado", dinero)
		return true
	return false  # sin fondos

# --- Inventario ---
func añadir_item(item: Item) -> void:
	inventario_items.append(item)

func equipar_item(item: Item) -> void:
	item_equipado = item
	emit_signal("item_equipado_cambiado", item)

func desequipar_item() -> void:
	item_equipado = null
	emit_signal("item_equipado_cambiado", null)

# --- Getters para los minijuegos ---
func get_riesgo_fallo() -> float:
	if item_equipado:
		return item_equipado.riesgo_fallo
	return 0.0

func get_bonus_tiempo() -> float:
	if item_equipado:
		return item_equipado.bonificador_tiempo
	return 0.0

func get_tipo_herramienta() -> String:
	if item_equipado:
		return item_equipado.tipo_herramienta
	return "general"

# --- Guardado ---
func guardar_progreso() -> void:
	var data = {
		"dinero": dinero,
		"item_equipado": item_equipado.resource_path if item_equipado else "",
		"inventario": inventario_items.map(func(i): return i.resource_path)
	}
	var archivo = FileAccess.open("user://save.json", FileAccess.WRITE)
	archivo.store_string(JSON.stringify(data))

func cargar_progreso() -> void:
	if not FileAccess.file_exists("user://save.json"):
		return
	var archivo = FileAccess.open("user://save.json", FileAccess.READ)
	var data = JSON.parse_string(archivo.get_as_text())
	
	dinero = data["dinero"]
	inventario_items = data["inventario"].map(
		func(path): return load(path) if path != "" else null
	).filter(func(i): return i != null)
	if data["item_equipado"] != "":
		item_equipado = load(data["item_equipado"])
