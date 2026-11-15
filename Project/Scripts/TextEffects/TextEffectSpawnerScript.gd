extends Node3D
var camera :Camera3D
@export var canvasLayer : CanvasLayer


const TEXT_EFFECT_GOTCHA = preload("uid://p50p7vavkpoj") ## Eskil was here


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	GameManager.food_got_spitted.connect(spawnTextEffect) ## Eskil was here


func spawnTextEffect(effect: PackedScene = TEXT_EFFECT_GOTCHA):  ## Eskil was here (TEXT_EFFECT_GOTCHA är nu alltid default)
	var new_effect := effect.instantiate() as TextEffect
	if (new_effect == null):
		print_debug("Tried spawning a text effect that is not a text effect")
	new_effect.position = camera.unproject_position(global_transform.origin)
	
	canvasLayer.add_child(new_effect)
