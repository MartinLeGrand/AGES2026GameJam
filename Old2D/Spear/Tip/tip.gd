class_name Tip extends Area2D


@export var spear: Spear = null


func _on_body_entered(body: Node2D) -> void:
	if body is Food:
		body.try_get_speared(self)
