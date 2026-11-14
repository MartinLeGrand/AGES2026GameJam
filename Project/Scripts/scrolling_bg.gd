extends TextureRect

var passed_time: float = 0.0

func _process(delta: float) -> void:
	passed_time += delta * 0.3
	
	material.set_shader_parameter("offset", passed_time)
