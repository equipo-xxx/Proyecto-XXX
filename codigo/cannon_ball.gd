extends RigidBody3D
class_name CannonBall

var direction: Basis
var ball_speed: float = 100.0


func _ready() -> void:
	# Multiplicamos la velocidad por el vector hacia adelante (-z) de la rotación del cañón
	apply_impulse(-direction.z * ball_speed)
	
	await get_tree().create_timer(3.0).timeout
	queue_free()
