extends StaticBody3D

#interact
var player
var can_interact: bool = false
var is_mounted: bool = false
@onready var cannon_cam: Camera3D = $cannonBarrel/Camera3D

#move cannon
var cam_sens: float = 0.003
@onready var cannon: Node3D = $cannonBarrel
@onready var player_stand_point: Node3D = $player_stand_point

#shoot
var cannon_ball_scene: PackedScene = load("res://escenas/cannon_ball.tscn")
@onready var shoot_point: Node3D = $cannonBarrel/shoot_point
var ammo: int = 3  # <--- Cantidad máxima de balas


func _input(event: InputEvent) -> void:
	#montarse al cañon
	if event.is_action_pressed("interact") and can_interact:
		mount()
	#mover el cañon
	if event is InputEventMouseMotion and is_mounted:
		rotate_y(-event.relative.x * cam_sens)
		cannon.rotate_x(-event.relative.y * cam_sens)
		cannon.rotation.x = clampf(cannon.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		player.global_position = Vector3(player_stand_point.global_position.x, player.global_position.y, player_stand_point.global_position.z)
		player.global_rotation = player_stand_point.global_rotation
	#disparar el cañon
	if event.is_action_pressed("fire") and is_mounted:
		shoot()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player = body
		can_interact = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player":
		can_interact = false


func mount():
	is_mounted = !is_mounted
	if is_mounted:
		player.velocidad = 0
		cannon_cam.current = true
	else:
		player.velocidad = 200
		cannon_cam.current = false


func shoot():
	# Si ya no quedan balas, no dispara
	if ammo <= 0:
		print("¡Sin munición!")
		return

	# Resta una bala y dispara
	ammo -= 1
	var ball = cannon_ball_scene.instantiate()
	ball.direction = shoot_point.global_transform.basis
	ball.global_position = shoot_point.global_position
	get_parent().add_child(ball)
