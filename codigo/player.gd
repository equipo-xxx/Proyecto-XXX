extends CharacterBody3D
class_name Jugador

## CAMINAR VARIABLES ##
@export var velocidad: float = 6.0
var direccion: Vector3

## MOVER CAMARA VARIABLES ##
@export var sensibilidad: float = 0.001
@onready var camara: Camera3D = $Camera3D

## LANZACOHETES ##
@export var cohete_scene: PackedScene
var _tiene_lanzacohetes: bool = false


func _physics_process(_delta: float) -> void:
	caminar()
	move_and_slide()


func _input(event: InputEvent) -> void:
	mover_camara(event)


func _process(_delta: float) -> void:
	ocultar_raton()


func caminar() -> void:
	direccion = transform.basis * Vector3(
		Input.get_axis("izquierda", "derecha"),
		0,
		Input.get_axis("adelante", "atras")
	).normalized()

	# En Godot 4 NO se multiplica por delta al asignar a velocity
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad


func mover_camara(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotar al jugador en el eje Y
		rotate_y(-event.relative.x * sensibilidad)

		# Rotar la cámara en el eje X con límite
		camara.rotate_x(-event.relative.y * sensibilidad)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func ocultar_raton() -> void:
	if Input.is_action_just_pressed("ocultar_raton"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func recibir_danio(_cantidad: int) -> void:
	print("💀 El jugador ha muerto.")
	get_tree().reload_current_scene()


func equipar_lanzacohetes() -> void:
	_tiene_lanzacohetes = true
	print("🚀 Lanzacohetes equipado en el jugador.")


func _unhandled_input(event: InputEvent) -> void:
	if _tiene_lanzacohetes and event.is_action_pressed("ui_accept"):
		_disparar_cohete()


func _disparar_cohete() -> void:
	if not cohete_scene:
		push_error("No asignaste la escena del cohete en el Inspector del jugador.")
		return

	_tiene_lanzacohetes = false
	var cohete = cohete_scene.instantiate()
	get_tree().current_scene.add_child(cohete)

	cohete.global_position = global_position + Vector3(0, 1.5, 0)
	cohete.global_transform.basis = global_transform.basis
