class_name Fire extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is Food:
		body.over_fire = true
		print("we in fire now")


func _on_body_exited(body: Node3D) -> void:
	if body is Food:
		body.over_fire = false
