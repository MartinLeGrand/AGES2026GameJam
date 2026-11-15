extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://bk7m2ifpl8vbh"))
	print_debug("Start Game")

func _on_button_2_pressed() -> void:
	print_debug("Quit Game")
