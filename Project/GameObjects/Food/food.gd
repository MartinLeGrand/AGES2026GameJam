class_name Food extends RigidBody3D
## Base class for food


const STANDARD_MATERIAL = preload("uid://cx6utliwik3uh")

enum Type {
	MUSHROOM,
	PINEAPPLE,
	TOMATO,
	ZUCCHINI,
}


## Max precentage of cook_time until next stage
## 
enum Prepared {
	NULL = 0,
	RAW = 1,
	MEDIUM_RARE = 2,
	COOKED = 3, ## Cook_time
	BURNT = 4,
	COAL = 5 ## Twice cook_time
}

@export var type: Type
@export var points: float = 1000 ## Value of food when calculating score
@export var cook_time: float = 5.0 ## Seconds until perfectly cooked
#@export var burn_time: float  2.0 ## Seconds after cooked until burnt.
@export var cooked_color: Color = Color(0.804, 0.45, 0.27, 1.0)
@export var burnt_color: Color = Color()


@export_category("Spit")
@export_range(0.0, 100.0, 1.0) var spit_velocity_needed: float = 50.0 ## Velocity needed to penetrate food 
@export var spit_grace_period: float = 0.1 ## Time before position follows spear

@export_category("Spawn")
@export var gravity: float = 1.0 ## Speed downwards
@export var max_spin_force: float = 1 ## Food spins, but how much?
@export_range(0.0, 1.0) var spin_randomness: float = 1.0 ## Zero means no spin. This is stupid. Should be 1.


var falling_collision_mask: int = 7 ## Detect HOOK 1, SPIT 2, FOOD 3,
var speared_collision_mask: int = 13 ## Detect HOOK, FOOD

var over_fire: bool = false ## Set by fire when food collides with fire area
var prepared: Prepared = Prepared.RAW ## How the food was cooked

var food_mesh: MeshInstance3D = null
var food_material: StandardMaterial3D = null ## 
var outline_material: StandardMaterial3D = null
var outline_clr: Color = Color.WHITE
var start_color: Color = Color.WHITE
var cooked_amount: float = 0: ## Seconds food has been cooked/over the fire
	set(value):
		if not food_material or not start_color:
			return
		cooked_amount = value
		set_cooked_color()
		set_prepared_status()





## Used to control food when speared
var grace_timer: Timer = null
var spit: Spit = null
var follow_spear = false
var is_speared: bool = false
var _speared_y: float = 0.0
var _start_z: float = 0


func _ready() -> void:
	collision_mask = falling_collision_mask
	## Förlåt mig gud för detta. Gör mesh och material unikt
	for child: Node3D in get_children():
		if child is MeshInstance3D:
			for mesh_child: Node3D in child.get_children():
				if mesh_child is MeshInstance3D:
					outline_material = mesh_child.get_surface_override_material(0).duplicate()
					outline_clr = outline_material.albedo_color
					mesh_child.set_surface_override_material(0, outline_material)
			
			child.mesh = child.mesh.duplicate_deep()
			food_material = STANDARD_MATERIAL.duplicate()
			
			child.mesh.surface_set_material(0, food_material)
			start_color = food_material.albedo_color ## it's just white my dude
			break
	
	
	GameManager.spawned_food_counter += 1
	
	grace_timer = Timer.new()
	grace_timer.timeout.connect(move_with_spear)
	add_child(grace_timer)
	
	
	_start_z = position.z
	
	gravity_scale = gravity * GameManager.gravity_mult
	## Apply random spin
	#apply_force(Vector3(0, 0, rnd_float()) * spin_randomness, 
		#Vector3(0, 0, rnd_float()) * spin_randomness)
	apply_torque_impulse(Vector3(rnd_float(), rnd_float(), 0.0) * spin_randomness)


func _process(delta: float) -> void:
	if over_fire:
		cooked_amount += delta
		
		#print(cooked_amount)
	

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


## 1000 is best. Get points. Dunno bout this one
func cooked_score() -> float:
	#print(prepared)
	
	var cooked: float = absf(cooked_amount - (cook_time))
	#print(100.0 / float(prepared))
	return points - (points * cooked)


func set_cooked_color() -> void:
	if cooked_amount <= cook_time:
			var t: float = clampf(cooked_amount / cook_time, 0.0, 1.0)
			food_material.albedo_color = start_color.lerp(cooked_color, t)
			outline_material.albedo_color = outline_clr.lerp(cooked_color*outline_clr, t)
	else:
		var t: float = clampf((cooked_amount - cook_time) / cook_time, 0.0, 1.0)
		food_material.albedo_color = cooked_color.lerp(burnt_color, t)
		outline_material.albedo_color = (cooked_color*outline_clr).lerp(burnt_color*outline_clr, t)

func set_prepared_status() -> void:
	if cooked_amount <= (cook_time * (0.25)):
			prepared = Prepared.RAW
	elif cooked_amount <= (cook_time * 0.5):
		prepared = Prepared.MEDIUM_RARE
	elif cooked_amount <= (cook_time * (1.0)):
		prepared = Prepared.COOKED
	elif cooked_amount <= (cook_time * (1.5)):
		prepared = Prepared.BURNT
	elif cooked_amount <= (cook_time * (2.0)):
		prepared = Prepared.COAL


class Request extends RefCounted:
	const MAX_AMOUNT: int = 5
	var type: Type = Type.TOMATO
	var amount: int = 1
	var prepared: Prepared = Prepared.COOKED
	
	## Förlåt för denna kod
	static func rnd_request(specific_type: int = -1) -> Request:
		var req: Request = Request.new()
		req.amount = randi_range(1, MAX_AMOUNT)
		if specific_type == -1:
			req.type = Type.values().pick_random()
		else:
			req.type = Type.values()[specific_type]
		req.prepared = Prepared.values().pick_random()
		return req
