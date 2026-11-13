class_name Food extends RigidBody2D
## Base class for food

@export var gravity: float = 1.0 ## Speed downwards
@export var max_spin_force: float = 1200 ## Food spins, but how much?
@export_range(0.0, 1.0) var spin_randomness: float = 1.0 ## Zero means no spin. This is stupid. Should be 1.


func _ready() -> void:
	gravity_scale = gravity
	## Apply random spin
	apply_force(Vector2(rnd_float(),rnd_float()) * spin_randomness, 
		Vector2(0, rnd_float()) * spin_randomness)


func rnd_float(min_max: float = max_spin_force) -> float:
	return randf_range(-min_max, min_max)
