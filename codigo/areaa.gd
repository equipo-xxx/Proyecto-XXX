extends Area3D
class_name ZonaVictoria

@export var bloques_necesarios: int = 1
@export var escena_menu: PackedScene = preload("res://escenas/nivel_1_superado.tscn")

var _bloques_caidos: int = 0
var _bloques_procesados: Array[Node3D] = []
var _victoria_alcanzada: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if _victoria_alcanzada:
		return

	if body is RigidBody3D and not body.name.contains("cannon_ball"):
		if not _bloques_procesados.has(body):
			_bloques_procesados.append(body)
			_bloques_caidos += 1
			print("✅ Bloque caído: ", _bloques_caidos, " / ", bloques_necesarios)

			if _bloques_caidos >= bloques_necesarios:
				_victoria_alcanzada = true
				_mostrar_victoria()


func _mostrar_victoria() -> void:
	await get_tree().create_timer(2.5).timeout
	var menu = escena_menu.instantiate()
	var canvas = get_tree().current_scene.find_child("CanvasLayer", true, false)
	if canvas:
		canvas.add_child(menu)
	else:
		get_tree().current_scene.add_child(menu)
	_animar_aparicion(menu)


func _animar_aparicion(nodo_menu: Node) -> void:
	if "modulate" in nodo_menu:
		nodo_menu.modulate.a = 0.0

	if nodo_menu is Control:
		nodo_menu.pivot_offset = nodo_menu.size / 2.0
		nodo_menu.scale = Vector2(0.7, 0.7)

	var tween = create_tween().set_parallel(true)
	if "modulate" in nodo_menu:
		tween.tween_property(nodo_menu, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if nodo_menu is Control:
		tween.tween_property(nodo_menu, "scale", Vector2.ONE, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
