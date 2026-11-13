class_name Tip2D extends Area2D


@export var spear: Spear2D = null


func _on_body_entered(body: Node2D) -> void:
	if body is Food2D:
		body.try_get_speared(self)
