extends Area3D
class_name Cohete

@export var velocidad: float = 35.0
@export var tiempo_vida: float = 5.0 # Autodestrucción si falla el tiro
@export var escena_victoria: PackedScene


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_iniciar_temporizador_vida()


func _physics_process(delta: float) -> void:
	# Si se movía marcha atrás, cambiamos el '-' por '+' para que avance hacia adelante
	global_position += transform.basis.z * velocidad * delta


func _on_body_entered(body: Node) -> void:
	# Ignora al propio jugador si el cohete nace tocando su colisión
	if body.has_method("caminar"):
		return

	# Si impacta al jefe
	if body.has_method("recibir_danio"):
		body.recibir_danio(1)
		_mostrar_victoria()

	# Se destruye al chocar contra cualquier objeto (paredes, escenario o jefe)
	queue_free()


func _iniciar_temporizador_vida() -> void:
	await get_tree().create_timer(tiempo_vida).timeout
	if is_instance_valid(self):
		queue_free()


func _mostrar_victoria() -> void:
	if escena_victoria:
		var pantalla = escena_victoria.instantiate()
		get_tree().current_scene.add_child(pantalla)
