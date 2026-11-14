class_name Tip extends Area3D


@export var spit: Spit = null


func _on_body_entered(body: Node3D) -> void:
	if body is Food:
		body.try_get_spitted(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Food:
		body.release_from_spit()
