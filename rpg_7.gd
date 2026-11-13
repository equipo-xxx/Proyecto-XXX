extends Area3D
class_name LanzacohetesItem

@export var velocidad: float = 35.0
@export var escena_victoria: PackedScene

var _disparado: bool = false


func _ready() -> void:
	set_physics_process(false)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _disparado:
		# Se cambió a '+' para que avance hacia la dirección opuesta
		global_position += transform.basis.z * velocidad * delta


func _on_body_entered(body: Node) -> void:
	if not _disparado:
		if body.has_method("caminar") or body is CharacterBody3D:
			_disparado = true
			set_physics_process(true)
			print("🚀 Lanzacohetes disparado. ¡Victoria en 5 segundos!")
			
			# Espera 5 segundos automáticamente
			await get_tree().create_timer(10.0).timeout
			
			_mostrar_victoria()
			queue_free()


func _mostrar_victoria() -> void:
	if escena_victoria:
		var pantalla = escena_victoria.instantiate()
		get_tree().current_scene.add_child(pantalla)
	else:
		print("❌ Recordá asignar la Escena Victoria en el Inspector del Lanzacohetes.")
