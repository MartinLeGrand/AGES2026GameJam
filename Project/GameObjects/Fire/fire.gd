class_name Fire extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Food:
		body.over_fire = true
		#if body.is_speared:
			#FXManager.request_fx(FXManager.FX.START_COOKING)

func _on_body_exited(body: Node3D) -> void:
	if body is Food:
		body.over_fire = false
		#if body.is_speared:
			#FXManager.request_fx(FXManager.FX.STOP_COOKING)
