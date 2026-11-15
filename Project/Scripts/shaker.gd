class_name ShakyCamera extends Camera3D

var trauma: float = 0.0
var start_position: Vector3

func _ready() -> void:
	if not process_mode == ProcessMode.PROCESS_MODE_ALWAYS:
		process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if trauma <= 0.0:
		return
	
	trauma -= delta
	
	h_offset = randf_range(-1, 1) * trauma
	v_offset = randf_range(-1, 1) * trauma

func add_trauma(trauma_addition: float = 0.4):
	trauma += trauma_addition
	
	trauma = clampf(trauma, 0.0, 2.0)
