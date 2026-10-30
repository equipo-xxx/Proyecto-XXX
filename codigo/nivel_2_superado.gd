class_name nivel_2_superado
extends Control

@export_file("*.tscn") var escena_destino: String
func _on_nivel_3_pressed() -> void:
	if escena_destino:
		get_tree().change_scene_to_file(escena_destino)
