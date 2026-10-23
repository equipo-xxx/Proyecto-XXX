extends RigidBody3D

var direction: Basis
var ball_speed: float = 100

func _ready() -> void:
	# Multiplicamos la velocidad por el vector hacia adelante (-z) de la rotación del cañón
	apply_impulse(-direction.z * ball_speed)
	
	await get_tree().create_timer(3).timeout
	queue_free()
