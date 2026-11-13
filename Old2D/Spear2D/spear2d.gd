class_name Spear2D extends CharacterBody2D


@export var speed: float = 50.0 ## Speed in x-direction
@export var slidy_brakes: bool = true ## False: Instant brakes. True sliiidy
@export var brake_force: float = 10.0  ## NOTE: Slidy brakes must be true
@export var max_move_x: float = 100.0 ## Nr of px allowed to move in x-direction from start pos.


var _max_x: float = 0.0 ## Max local x
var _min_x: float = 0.0 ## Min local x
var lock_y: float = 0.0


func _ready() -> void:
	## Ugly aa way too limit x movemt
	_max_x = position.x + max_move_x
	_min_x = position.x - max_move_x
	lock_y = position.y


func _physics_process(_delta: float) -> void:
	## PLAYER INPUT
	var dir: float = Input.get_axis("ui_left", "ui_right")
	if dir:
		velocity.x += speed * dir
	elif abs(velocity.x) > 0.01 and slidy_brakes:
		velocity.x -= brake_force * sign(velocity.x)
	else:
		velocity.x = 0
	move_and_slide()
	
	## LIMIT X movement
	position.x = clampf(position.x, _min_x, _max_x)
	if is_equal_approx(position.x, _min_x) or is_equal_approx(position.x, _max_x):
		velocity.x = 0
	
	## Lock Y
	position.y = lock_y
