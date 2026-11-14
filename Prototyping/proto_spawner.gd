class_name PrototypeSpawner extends Node3D

@export var spawn_positions: Array[Vector3]
@export var proto_foods: Array[PackedScene]

func create_foods():
	var new_food = proto_foods.pick_random().instantiate()
	
	add_child(new_food)
	
	new_food.global_position = spawn_positions.pick_random()
	
	await get_tree().create_timer(2.0).timeout
	
	create_foods()

func _ready() -> void:
	create_foods()
