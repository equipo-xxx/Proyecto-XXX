extends Button


func _on_pressed() -> void:
	get_tree().quit()


func _on_volver_a_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
