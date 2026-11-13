extends Area3D
class_name ZonaVictoria

@export var bloques_necesarios: int = 1

var bloques_caidos: int = 0
var bloques_procesados: Array[Node3D] = []
var victoria_alcanzada: bool = false

var escena_menu = preload("res://escenas/nivel_1_superado.tscn")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if victoria_alcanzada:
		return

	if body is RigidBody3D and not body.name.contains("cannon_ball"):
		if not bloques_procesados.has(body):
			bloques_procesados.append(body)
			bloques_caidos += 1
			print("✅ Bloque caído: ", bloques_caidos, " / ", bloques_necesarios)

			if bloques_caidos >= bloques_necesarios:
				victoria_alcanzada = true
				mostrar_victoria()


func mostrar_victoria() -> void:
	print("⏳ Bloque detectado. Esperando 2.5 segundos...")
	
	# 1. Espera de 2.5 segundos sin congelar la física del juego
	await get_tree().create_timer(2.5).timeout
	
	print("¡GANASTE EL NIVEL!")
	
	# 2. Instanciar el menú
	var menu = escena_menu.instantiate()
	
	# Prioriza agregarlo a un CanvasLayer si existe en la escena para que se dibuje arriba de todo
	var canvas = get_tree().current_scene.find_child("CanvasLayer", true, false)
	if canvas:
		canvas.add_child(menu)
	else:
		get_tree().current_scene.add_child(menu)
	
	# 3. Aplicar efecto de aparición bonito
	animar_aparicion(menu)


func animar_aparicion(nodo_menu: Node) -> void:
	# Prepara el menú como transparente desde el inicio
	if "modulate" in nodo_menu:
		nodo_menu.modulate.a = 0.0
	
	# Si es un nodo de interfaz (Control/Node2D), centramos el pivote y lo achicamos un poco
	if nodo_menu is Control:
		nodo_menu.pivot_offset = nodo_menu.size / 2.0
		nodo_menu.scale = Vector2(0.7, 0.7)
	
	# Creamos el Tween para animar propiedades en paralelo
	var tween = create_tween().set_parallel(true)
	
	# Animación 1: Transparencia (0% a 100% en 0.5 seg)
	if "modulate" in nodo_menu:
		tween.tween_property(nodo_menu, "modulate:a", 1.0, 0.5)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
	
	# Animación 2: Crecimiento con rebote suave (Back Ease)
	if nodo_menu is Control:
		tween.tween_property(nodo_menu, "scale", Vector2.ONE, 0.6)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)
