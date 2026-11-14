class_name Food extends RigidBody3D
## Base class for food

enum Type {
	MUSHROOM,
	PINEAPPLE,
	TOMATO,
	ZUCCHINI,
}


@export var type: Type
@export var gravity: float = 1.0 ## Speed downwards
@export var max_spin_force: float = 1 ## Food spins, but how much?
@export_range(0.0, 1.0) var spin_randomness: float = 1.0 ## Zero means no spin. This is stupid. Should be 1.
@export_range(0.0, 100.0, 1.0) var spit_velocity_needed: float = 50.0 ## Velocity needed to penetrate food 
@export var spit_grace_period: float = 0.1 ## Time before position follows spear

var grace_timer: Timer = null
var spit: Spit = null
var is_speared: bool = false
var follow_spear = false

var _speared_y: float = 0.0
var falling_collision_mask: int = 7
var speared_collision_mask: int = 13

var _start_z: float = 0


func _ready() -> void:
	GameManager.spawned_food_counter += 1
	
	grace_timer = Timer.new()
	grace_timer.timeout.connect(move_with_spear)
	add_child(grace_timer)
	
	
	_start_z = position.z
	
	gravity_scale = gravity
	## Apply random spin
	#apply_force(Vector3(0, 0, rnd_float()) * spin_randomness, 
		#Vector3(0, 0, rnd_float()) * spin_randomness)
	apply_torque_impulse(Vector3(rnd_float(), rnd_float(), 0.0) * spin_randomness)


func _physics_process(_delta: float) -> void:
	position.z = _start_z ## Lock z axis
	if is_speared:
		linear_velocity.y = 0
		position.y = _speared_y
		if follow_spear:
			linear_velocity.x = spit.velocity.x
		else:
			linear_velocity.x = 0
		pass


func try_get_spitted(tip: Tip) -> void:
	if not tip:
		push_error("tip null")
		return
	if not is_speared and absf(tip.spit.velocity.x + tip.spit.velocity.x) > spit_velocity_needed:
		is_speared = true
		#freeze = true
		_speared_y = position.y
		collision_mask = speared_collision_mask
		spit = tip.spit
		grace_timer.start(spit_grace_period)
		
		lock_rotation = true
		GameManager.food_spitted(self)


func release_from_spit() -> void:
	is_speared = false
	#freeze = false
	collision_mask = falling_collision_mask
	lock_rotation = false
	GameManager.food_fell_off(self)


func rnd_float(min_max: float = max_spin_force) -> float:
	return randf_range(-min_max, min_max)


func move_with_spear(follow: bool = true) -> void:
	follow_spear = follow
