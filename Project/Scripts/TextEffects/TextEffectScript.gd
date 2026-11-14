class_name TextEffect
extends Control
@export var animation : String = "anim_texteffect_default"
var animator : AnimationPlayer

func _ready() -> void:
	animator = $AnimationPlayer
	animator.play(animation)

func _on_timer_timeout() -> void:
	$".".queue_free()
