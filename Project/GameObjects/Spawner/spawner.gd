class_name Spawner extends Node3D
## Adds all childs from SpawnPoints and adds them as spawn points


@export var is_spawning: bool = true:
	set(value):
		is_spawning = value
		if spawn_timer.is_stopped():
			spawn_timer.start(spawn_time)
@export var spawn_time: float = 1.0
@export var obj_to_spawn: Array[PackedScene] ## Foods to spawn


@onready var spawn_points: Node3D = $SpawnPoints
@onready var spawn_timer: Timer = $SpawnTimer

var spawn_points_list: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Add all spawnpoints to list
	for point: Node in spawn_points.get_children():
		if point is Node3D:
			spawn_points_list.append(point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_object() -> void:
	var obj := obj_to_spawn.pick_random().instantiate() as Node3D
	if obj:
		add_child(obj)
		var spawn_pos: Vector3 = spawn_points_list.pick_random().global_position
		obj.global_position = spawn_pos



func _on_spawn_timer_timeout() -> void:
	spawn_object()
	
	## Restart Timer
	if is_spawning:
		spawn_timer.start(spawn_time * GameManager.spawn_speed_mult)
