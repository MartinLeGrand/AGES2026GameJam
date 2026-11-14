class_name collector extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Food:
		GameManager.food_collected(body)
		body.queue_free()
	if body is Spit:
		body.queue_free()
