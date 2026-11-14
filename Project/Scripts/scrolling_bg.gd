extends TextureRect

var passed_time: float = 0.0

func _process(delta: float) -> void:
	passed_time += delta
	
	set_instance_shader_parameter("offset", passed_time)
