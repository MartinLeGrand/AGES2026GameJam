class_name Tip extends Area3D


@export var spit: Spit = null


func _on_body_entered(body: Node3D) -> void:
	if body is Food:
		body.try_get_speared(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Food:
		body.try_release_spear()
