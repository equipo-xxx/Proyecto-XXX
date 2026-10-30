extends Control
class_name MenuPrincipal


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/world.tscn")
