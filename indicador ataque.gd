extends Node3D
class_name IndicadorAtaque

var _radio: float = 1.0
var _duracion: float = 1.0
var _objetivo: Node3D
var _color: Color = Color(1, 0, 0, 0.6)


func iniciar(posicion: Vector3, radio: float, duracion: float, objetivo: Node3D, color: Color = Color(1, 0, 0, 0.6)) -> void:
	global_position = posicion
	_radio = radio
	_duracion = duracion
	_objetivo = objetivo
	_color = color
	_construir_malla()
	_iniciar_conteo()


func _construir_malla() -> void:
	var mesh_inst = MeshInstance3D.new()
	var cilindro = CylinderMesh.new()
	cilindro.top_radius = _radio
	cilindro.bottom_radius = _radio
	cilindro.height = 0.05
	mesh_inst.mesh = cilindro

	var mat = StandardMaterial3D.new()
	mat.albedo_color = _color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.emission_enabled = true
	mat.emission = _color
	mat.emission_energy_multiplier = 2.0
	mesh_inst.material_override = mat

	add_child(mesh_inst)

	var tween = create_tween().set_loops()
	tween.tween_property(mat, "albedo_color:a", 0.1, 0.2)
	tween.tween_property(mat, "albedo_color:a", _color.a, 0.2)


func _iniciar_conteo() -> void:
	await get_tree().create_timer(_duracion).timeout
	_evaluar_danio_jugador()
	queue_free()


func _evaluar_danio_jugador() -> void:
	if not is_instance_valid(_objetivo):
		return

	var pos_plana_objetivo = Vector3(_objetivo.global_position.x, global_position.y, _objetivo.global_position.z)
	if global_position.distance_to(pos_plana_objetivo) <= _radio:
		if _objetivo.has_method("recibir_danio"):
			_objetivo.recibir_danio(999)
