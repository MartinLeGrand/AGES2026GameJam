class_name PrototypeSpit extends Node3D

var input_x = 0.0

func _process(delta: float) -> void:
	input_x = lerpf(input_x, Input.get_axis("ui_left", "ui_right") * 24.0, 24.0 * delta)
	
	translate_object_local(Vector3(input_x * delta, 0, 0))

func skewer_object(target: Node3D):
	print("Hit!")
	
	target.get_parent_node_3d().skewer(self)
