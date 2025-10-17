extends Control

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")

func _on_begin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
