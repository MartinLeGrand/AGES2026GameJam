class_name Food extends RigidBody2D
## Base class for food

@export var gravity: float = 1.0 ## Speed downwards
@export var max_spin: float = 1200
@export_range(0.0, 1.0) var spin_randomness: float = 1.0 


func _ready() -> void:
	gravity_scale = gravity
	apply_force(Vector2(rnd_float(),rnd_float()) * spin_randomness, 
		Vector2(0, rnd_float()) * spin_randomness)


func rnd_float(min_max: float = max_spin) -> float:
	return randf_range(-min_max, min_max)
