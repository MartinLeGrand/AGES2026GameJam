extends Node


@export_category("Modifiers")
@export var use_modifiers: bool = false
@export var gravity_mult: float = 1.0 ## Multiples gravity for NEW foods
@export var spawn_speed_mult: float = 1.0 ## Less means more frequent spawns!
@export var spit_speed_mult: float = 1.0

var foods_on_spit: Array[Food] = [] ## Could just be array of enum...
var spawned_food_counter: int = 0 ## Updated by Food when it's added to tree
var order: Array[Food.Request] = []


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


func enter_feeding(spit: Spit) -> void:
	for food in foods_on_spit:
		food.freeze = true
		food.reparent(spit)


func eat_food(food: Food) -> void:
	## Is in order?
	var food_in_order: bool = false
	var req_index: int = 0
	for request: Food.Request in order:
		if food.type == request.type and request.amount > 0:
			food_in_order = true
			break
		req_index += 1
	
	## Taste test
	if food_in_order:
		order[req_index].amount -= 1 ## Remove one amount from order
		
		## How was it cooked
		if food.prepared == order[req_index].prepared:
			print("amazing")
			## Await something
		elif food.prepared + 1 == order[req_index].prepared or food.prepared - 1 == order[req_index].prepared:
			print("decent")
			## Await something
		else:
			print("terribly cooked")
			## Await something
	else:
		print("Not in order at all!")
		## Await something
	
	food.queue_free()

func check_results() -> void:
	for request: Food.Request in order:
		var food_accepted: bool = false
		for food: Food in foods_on_spit:
			food_accepted = compare_food_to_request(food, request)
		if not food_accepted:
			print("Literally puking rn")


## Returns true if food was good
func compare_food_to_request(food: Food, request: Food.Request) -> bool:
	if food.type == request.type:
		if not request.amount > 0:
			print("Full!")
			return 0
		
		if food.prepared == request.prepared:
			print("amazing")
			return 1
		elif food.prepared + 1 == request.prepared or food.prepared - 1 == request.prepared:
			print("decent")
			return 1
		print("cooked badly")
	
	print("wrong vegetable")
	return 0


func create_order() -> void:
	pass

## Called by Collector when food enters its area
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
