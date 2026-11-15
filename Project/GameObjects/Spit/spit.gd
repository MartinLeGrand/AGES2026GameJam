class_name Spit extends CharacterBody3D


@export var max_speed: float = 12
@export var speed: float = 12.0 ## Speed in x-direction
@export var left_speed_mult: float = 1.01
@export var slidy_brakes: bool = false ## FIXME: Shakes. False: Instant brakes. True sliiidy
@export var brake_force: float = 10.0  ## NOTE: Slidy brakes must be true
@export var max_move_x: float = 14.0 ## Nr of meters allowed to move in x-direction from start pos.
var is_dashing: bool = false
@export var dash_length: float = 2
@export var dash_speed: float = 60
var start_dash_pos: float = 0

var _max_x: float = 0.0 ## Max local x
var _min_x: float = 0.0 ## Min local x
var lock_y: float = 0.0 
var lock_z: float = 0.0

@onready var pivot: Node3D = $Pivot


func _ready() -> void:
	## Ugly aa way too limit x movemt
	_max_x = position.x + max_move_x
	_min_x = position.x - max_move_x
	lock_y = position.y
	lock_z = position.z


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		is_dashing = true
		start_dash_pos = global_position.x
		velocity.x = -dash_speed
	
	if is_dashing:
		if global_position.x <= start_dash_pos-dash_length or \
		is_equal_approx(position.x, _min_x):
			is_dashing = false
	else:
		## PLAYER INPUT
		var dir: float = Input.get_axis("ui_left", "ui_right")
		if dir:
			velocity.x += speed * dir * GameManager.spit_speed_mult
			if dir < 0:
				velocity.x *= left_speed_mult
			velocity.x = clampf(velocity.x, -max_speed * GameManager.spit_speed_mult * left_speed_mult, max_speed * GameManager.spit_speed_mult) 
		elif abs(velocity.x) > 0 and slidy_brakes:
			velocity.x = move_toward(velocity.x, 0, brake_force) 
		else:
			velocity.x = 0
	move_and_slide()
	
	
	## LIMIT X movement
	position.x = clampf(position.x, _min_x, _max_x)
	if is_equal_approx(position.x, _min_x) or is_equal_approx(position.x, _max_x):
		velocity.x = 0
	
	## Lock Y and Z
	position.y = lock_y
	position.z = lock_z
	#print(velocity)
