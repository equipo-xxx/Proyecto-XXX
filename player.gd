class_name Jugador
extends CharacterBody3D

@export var speed: float = 5.0
@export var Fuerza_salto: float = 4.0
@export var Sensivilidad_mouse: float = 0.0005

@onready var camera: Camera3D = $Camera3D

var pitch: float = 0.0 # tope vertical de la camara

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Sensivilidad_mouse)

		pitch = clamp(pitch - event.relative.y * Sensivilidad_mouse, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = pitch

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var direccion = Vector3.ZERO

	if Input.is_action_pressed("mover_adelante"):
		direccion -= transform.basis.z
	if Input.is_action_pressed("mover_atras"):
		direccion += transform.basis.z
	if Input.is_action_pressed("Mover_derecha"):
		direccion -= transform.basis.x
	if Input.is_action_pressed("mover_izquierda"):
		direccion += transform.basis.x

	direccion = direccion.normalized()

	velocity.x = direccion.x * speed
	velocity.z = direccion.z * speed

	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		if Input.is_action_just_pressed("Jump"):
			velocity.y = Fuerza_salto

	move_and_slide()
