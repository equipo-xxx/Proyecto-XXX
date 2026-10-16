extends Area3D

# Cantidad de bloques que deben caer para ganar
@export var bloques_necesarios: int = 1
var bloques_caidos: int = 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	# Verificamos que sea un objeto rígido y que NO sea la bola de cañón
	if body is RigidBody3D and not body.name.contains("cannon_ball"):
		bloques_caidos += 1
		print("Bloques caídos: ", bloques_caidos)
		
		if bloques_caidos >= bloques_necesarios:
			ganar_nivel()


func ganar_nivel() -> void:
	print("¡GANASTE EL NIVEL!")
	# Aquí pones tu cartel de victoria o cambias de escena:
	# get_tree().change_scene_to_file("res://escenas/victoria.tscn")
