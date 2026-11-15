extends Node3D



func load_mainmenu() -> void:
	get_tree().change_scene_to_packed(preload("uid://cfv8kn57cs3su"))


func _on_button_pressed() -> void:
	load_mainmenu() # Replace with function body.
