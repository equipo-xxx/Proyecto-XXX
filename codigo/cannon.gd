extends StaticBody3D
class_name Cannon

# --- Referencias exportadas al Inspector ---
@export var pantalla_perdiste: Control
@export var c1: Camera3D
@export var c2: Camera3D

# --- Interacción y cámaras ---
var player: CharacterBody3D
var interac_canon: bool = false
var sob_canon: bool = false
@onready var cam_can: Camera3D = $can/Camera3D

# --- Movimiento del cañón ---
var cam_sens: float = 0.003
@onready var cannon: Node3D = $cannonBarrel
@onready var player_stand_point: Node3D = $player_stand_point

# --- Disparo y munición ---
var cannon_ball_scene: PackedScene = load("res://escenas/cannon_ball.tscn")
@onready var shoot_point: Node3D = $cannonBarrel/shoot_point
var ammo: int = 3


func _input(event: InputEvent) -> void:
	# Subirse / bajar del cañón
	if event.is_action_pressed("Interactuar") and (interac_canon or sob_canon):
		mount()
	
	# Mover / apuntar el cañón
	if event is InputEventMouseMotion and sob_canon and cannon:
		rotate_y(-event.relative.x * cam_sens)
		cannon.rotate_x(-event.relative.y * cam_sens)
		cannon.rotation.x = clampf(cannon.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		if player and player_stand_point:
			player.global_position = Vector3(player_stand_point.global_position.x, player.global_position.y, player_stand_point.global_position.z)
			player.global_rotation = player_stand_point.global_rotation

	# Disparar
	if event.is_action_pressed("fire") and sob_canon:
		shoot()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player" or body is CharacterBody3D:
		player = body as CharacterBody3D
		interac_canon = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player" or body is CharacterBody3D:
		interac_canon = false


func mount() -> void:
	sob_canon = !sob_canon
	if sob_canon:
		if player and "velocidad" in player:
			player.velocidad = 0
		cam_can.current = true
	else:
		if player and "velocidad" in player:
			player.velocidad = 200
		cam_can.current = false


func shoot() -> void:
	if ammo <= 0:
		print("¡Sin munición!")
		return

	ammo -= 1

	if c1: c1.current = true
	await get_tree().create_timer(0.5).timeout

	if cannon_ball_scene and shoot_point:
		var ball = cannon_ball_scene.instantiate()
		ball.direction = shoot_point.global_transform.basis
		ball.global_position = shoot_point.global_position
		get_parent().add_child(ball)

	await get_tree().create_timer(1.0).timeout
	if c2: c2.current = true

	await get_tree().create_timer(4.0).timeout
	if sob_canon: cam_can.current = true

	if ammo <= 0 and pantalla_perdiste:
		pantalla_perdiste.show()
		var pos_final: Vector2 = pantalla_perdiste.position
		pantalla_perdiste.position.y = -800
		var tween: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(pantalla_perdiste, "position", pos_final, 1.2)
