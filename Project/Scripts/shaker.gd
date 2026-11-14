extends Camera3D

var trauma: float = 0.0
var start_position: Vector3

func _process(delta: float) -> void:
	if trauma <= 0.0:
		return
	
	trauma -= delta
	
	h_offset = randf_range(-1, 1) * trauma
	v_offset = randf_range(-1, 1) * trauma

func add_trauma(trauma_addition):
	trauma += trauma_addition
	
	trauma = clampf(trauma, 0.0, 2.0)
