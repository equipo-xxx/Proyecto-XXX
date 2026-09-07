extends StaticBody3D

# INTERACTUAR
var player
var interac_canon: bool = false
var sob_canon: bool = false
@export var cam_sens: float = 0.005

@onready var cam_can: Camera3D = $can/Camera3D
@onready var cannon = $can
@onready var player_stand_point = $player_stand_point

func _process(_delta: float) -> void:
	pass

# SUBIRSE Y BAJAR DEL CAÑON
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interactuar") and (interac_canon or sob_canon):
		mount()

	# mover el cañon
	if event is InputEventMouseMotion and sob_canon:
		rotate_y(-event.relative.x * cam_sens)
		cannon.rotate_x(-event.relative.y * cam_sens)
		player.global_position = Vector3(player_stand_point.global_position.x, player.global_position.y, player_stand_point.global_position.z)
		player.global_rotation = player_stand_point.global_rotation

func mount():
	sob_canon = !sob_canon
	if sob_canon:
		player.speed = 0
		cam_can.current = true
	else:
		player.speed = 5
		cam_can.current = false

# SABER CUANDO ESTA EN EL RANGO
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player" or body is CharacterBody3D:
		player = body
		interac_canon = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player" or body is CharacterBody3D:
		interac_canon = false
