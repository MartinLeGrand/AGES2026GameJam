extends Node3D

@export var animplayer: AnimationPlayer

var passed_time: float
var start_position: Vector3

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	passed_time += delta
	
	global_position.y = start_position.y + (sin(passed_time * delta) * 16.0)
	
	if Input.is_action_just_pressed("chomp"):
		animplayer.play("croc_eat")
