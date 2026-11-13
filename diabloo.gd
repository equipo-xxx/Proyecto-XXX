extends Node3D
class_name JefeDiablo

signal jefe_derrotado

@export var vida_maxima: int = 1
@export var tiempo_espera_inicial: float = 45.0 # Espera 20 segundos antes de empezar
@export var tiempo_entre_ataques: float = 3.0
@export var altura_piso: float = 0.0
@export var objetivo: Node3D

var _vida_actual: int
var _en_combate: bool = false


func _ready() -> void:
	_vida_actual = vida_maxima

	# Busca automáticamente al nodo "player" en la escena si no se asignó en el Inspector
	if not objetivo:
		objetivo = get_tree().current_scene.find_child("player", true, false)

	print("⏳ El jefe esperará ", tiempo_espera_inicial, " segundos antes de atacar...")
	await get_tree().create_timer(tiempo_espera_inicial).timeout
	iniciar_combate()


func iniciar_combate(nuevo_objetivo: Node3D = null) -> void:
	if nuevo_objetivo:
		objetivo = nuevo_objetivo

	if not objetivo:
		push_error("JefeDiablo: No se encontró al jugador en la escena.")
		return

	_en_combate = true
	_bucle_combate()


func recibir_danio(cantidad: int) -> void:
	if not _en_combate or _vida_actual <= 0:
		return

	_vida_actual = max(0, _vida_actual - cantidad)
	if _vida_actual == 0:
		_morir()


func _bucle_combate() -> void:
	while _en_combate and _vida_actual > 0:
		await get_tree().create_timer(tiempo_entre_ataques).timeout
		if not _en_combate or _vida_actual <= 0:
			break

		var tipo_ataque = randi() % 3
		match tipo_ataque:
			0:
				await _lluvia_meteoros()
			1:
				await _erupcion_pies()
			2:
				await _ataque_en_cruz()


func _lluvia_meteoros() -> void:
	for i in range(4):
		if not _en_combate or not is_instance_valid(objetivo):
			break

		var offset = Vector3(randf_range(-8, 8), 0, randf_range(-8, 8))
		var pos_impacto = objetivo.global_position + offset
		pos_impacto.y = altura_piso

		_crear_indicador(pos_impacto, 2.5, 1.5, Color(1, 0.2, 0, 0.6))
		await get_tree().create_timer(0.4).timeout


func _erupcion_pies() -> void:
	for i in range(3):
		if not _en_combate or not is_instance_valid(objetivo):
			break

		var pos_fija = objetivo.global_position
		pos_fija.y = altura_piso

		_crear_indicador(pos_fija, 1.8, 1.0, Color(1, 0, 0, 0.8))
		await get_tree().create_timer(0.8).timeout


func _ataque_en_cruz() -> void:
	if not _en_combate or not is_instance_valid(objetivo):
		return

	var centro = objetivo.global_position
	centro.y = altura_piso
	var offset_distancia: float = 4.0

	var posiciones = [
		centro,
		centro + Vector3(offset_distancia, 0, 0),
		centro + Vector3(-offset_distancia, 0, 0),
		centro + Vector3(0, 0, offset_distancia),
		centro + Vector3(0, 0, -offset_distancia)
	]

	for pos in posiciones:
		_crear_indicador(pos, 2.0, 1.2, Color(0.8, 0, 1, 0.7))

	await get_tree().create_timer(1.2).timeout


func _crear_indicador(posicion: Vector3, radio: float, duracion: float, color: Color) -> void:
	var indicador = IndicadorAtaque.new()
	get_tree().current_scene.add_child(indicador)
	indicador.iniciar(posicion, radio, duracion, objetivo, color)


func _morir() -> void:
	_en_combate = false
	jefe_derrotado.emit()
	queue_free()
