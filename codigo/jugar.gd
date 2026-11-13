extends Button
class_name BotonJugar


func _pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/world.tscn")
