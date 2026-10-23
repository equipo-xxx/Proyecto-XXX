extends StaticBody3D

# INTERACTUAR
var player
var interac_canon: bool = false
var sob_canon: bool = false
@onready var cam_can: Camera3D = $can/Camera3D


# SUBIRSE Y BAJAR DEL CAÑON
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interactuar") and (interac_canon or sob_canon):
		mount()

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
	print("ENTRÓ ALGO AL ÁREA. Su nombre es: ", body.name)
	if body.name == "player" or body is CharacterBody3D:
		player = body
		interac_canon = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player" or body is CharacterBody3D:
		interac_canon = false
