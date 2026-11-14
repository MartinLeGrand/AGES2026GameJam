extends Node3D

@export var text_effect_spawner: Node3D
const TEXT_EFFECT_GOTCHA = preload("uid://p50p7vavkpoj")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		text_effect_spawner.spawnTextEffect(TEXT_EFFECT_GOTCHA)
