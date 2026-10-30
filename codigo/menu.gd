class_name menu
extends Control

func _on_salir_pressed() -> void:
	get_tree().quit()

@export_file("*.tscn") var escena_destino: String
func _on_jugar_pressed() -> void:
	if escena_destino:
		get_tree().change_scene_to_file(escena_destino)
