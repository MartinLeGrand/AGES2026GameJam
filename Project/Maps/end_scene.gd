extends Node3D
var animPlayer : AnimationPlayer

func _ready() -> void:
	animPlayer = $AnimationPlayer

func load_mainmenu() -> void:
	get_tree().change_scene_to_packed(preload("uid://cfv8kn57cs3su"))


func _on_button_pressed() -> void:
	animPlayer.play("end_exit")
