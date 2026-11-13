class_name Food extends RigidBody2D
## Base class for food

@export var gravity: float = 1.0 ## Speed downwards
@export var max_spin_force: float = 1200 ## Food spins, but how much?
@export_range(0.0, 1.0) var spin_randomness: float = 1.0 ## Zero means no spin. This is stupid. Should be 1.
@export var spear_velocity_needed: float = 400.0 

var is_speared: bool = false

var _speared_y: float = 0.0
var falling_collision_mask: int = 0
var speared_collision_mask: int = 2


func _ready() -> void:
	gravity_scale = gravity
	## Apply random spin
	apply_force(Vector2(rnd_float(),rnd_float()) * spin_randomness, 
		Vector2(0, rnd_float()) * spin_randomness)


func _physics_process(_delta: float) -> void:
	if is_speared:
		linear_velocity.y = 0
		position.y = _speared_y


func try_get_speared(tip: Tip) -> void:
	if not tip:
		push_error("tip null")
		return
	if not is_speared and absf(tip.spear.velocity.x + tip.spear.velocity.x) > spear_velocity_needed:
		is_speared = true
		_speared_y = position.y
		collision_mask = collision_mask


func rnd_float(min_max: float = max_spin_force) -> float:
	return randf_range(-min_max, min_max)
