extends Node


@export_category("Modifiers")
@export var use_modifiers: bool = false
@export var gravity_mult: float = 1.0 ## Multiples gravity for NEW foods
@export var spawn_speed_mult: float = 1.0 ## Less means more frequent spawns!
@export var spit_speed_mult: float = 1.0

var foods_on_spit: Array[Food] = [] ## Could just be array of enum...
var spawned_food_counter: int = 0 ## Updated by Food when it's added to tree


func _process(delta: float) -> void:
	#print(foods_on_spit)
	if not foods_on_spit.is_empty():
		foods_on_spit[0].cooked_score()

func spitted_food_count() -> void:
	return foods_on_spit.size()


## Called by Food when food is added to spit
func food_spitted(food: Food) -> void:
	## NOTE: ADD SCREEN SHAKE HERE 
	
	if not foods_on_spit.has(food):
		foods_on_spit.append(food)
		if use_modifiers:
			apply_modifier(food, true)


func food_collected(food: Food) -> void:
	pass


## Called by Food when food falls off spit
func food_fell_off(food: Food) -> void:
	if foods_on_spit.has(food):
		foods_on_spit.erase(food)
		if use_modifiers:
			apply_modifier(food, false)


func apply_modifier(food: Food, spitted: bool) -> void:
	match food.type:
		Food.Type.MUSHROOM:
			#if spitted 
			if spitted:
				gravity_mult += 1
			else:
				gravity_mult -= 1
			
		Food.Type.ZUCCHINI:
			if spitted:
				spit_speed_mult += 0.2
				print(spit_speed_mult)
			else:
				spit_speed_mult -= 0.2
		Food.Type.TOMATO:
			pass
		Food.Type.PINEAPPLE:
			pass
