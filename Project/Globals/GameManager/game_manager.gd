extends Node


var foods_on_spit: Array[Food] = [] ## Could just be array of enum...
var spawned_food_counter: int = 0 ## Updated by Food when it's added to tree


func _process(delta: float) -> void:
	print(foods_on_spit)

func spitted_food_count() -> void:
	return foods_on_spit.size()


## Called by Food when food is added to spit
func food_spitted(food: Food) -> void:
	## NOTE: ADD SCREEN SHAKE HERE 
	
	if not foods_on_spit.has(food):
		foods_on_spit.append(food)


## Called by Food when food falls off spit
func food_fell_off(food: Food) -> void:
	if foods_on_spit.has(food):
		foods_on_spit.erase(food)
