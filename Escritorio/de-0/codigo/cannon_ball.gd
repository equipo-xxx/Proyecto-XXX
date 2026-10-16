extends RigidBody3D

var direction: Basis
var ball_speed: float = 25

func _ready() -> void:
	apply_impulse(direction * Vector3(0, 0, -ball_speed))
	await get_tree().create_timer(3).timeout
	queue_free()
