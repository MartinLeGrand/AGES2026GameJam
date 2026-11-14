extends Node3D
var camera :Camera3D
@export var canvasLayer : CanvasLayer

func _ready() -> void:
	camera = get_viewport().get_camera_3d()


func spawnTextEffect(effect: PackedScene):
	var new_effect := effect.instantiate() as TextEffect
	if (new_effect == null):
		print_debug("Tried spawning a text effect that is not a text effect")
	new_effect.position = camera.unproject_position(global_transform.origin)
	
	canvasLayer.add_child(new_effect)
