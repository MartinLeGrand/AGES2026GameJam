extends Node


## Food Score
enum Review {
	AMAZING,
	DECENT,
	TERRIBLY_COOKED,
	WRONG_FOOD,
}


## SPIT
signal food_got_spitted ## bad name

### GAME
signal timer_finished ## When countdown timer finished. Use game end instead!
signal game_started ## When gameplay part of game starts
signal game_ended ## When gameplay part of game ends

#### ORDER 
signal order_created ## When order is created
signal order_changed ## Hopefully when order is changed

##### EATING
signal food_eaten(food: Food, review: Review) ## When a food is eaten
signal score_added(gained: int) ## When points are gained
signal feed_combo_gain ## When nr is added to feed_combo
signal feed_combo_reset ## When feed combo is reset
signal entire_spit_eaten ## When last food was eaten
signal combo_mult_applied ## When mult is applied at the end



@export_category("Game")
@export var game_running: bool = false ## why is this export?
@export var game_time: int = 120 ## Seconds until game ends

@export_category("Eating")
## When croc eats food, it reviews it from 1-4 based on request.
@export var review_mult: float = 1.25 ## Food_new_value = Food_base_value * (review_score * review_mult)

## Once player feeds the croc it'll eat everything on the spit, then create a new order.
@export var time_to_feed: float = 0.7 ## Grace period until new order, once feed has started
@export var feed_combo: int = 0: ## Multiplied to score when final food is eaten. +1 When feeding correct food, else set to zero
	set(value):
		feed_combo = value
		#if feed_combo <= 0:
			#feed_combo_reset.emit()
		#else:
			#feed_combo_gain.emit()

@export_category("Request")
@export var max_order_size: int = 6


@export_category("Modifiers")
@export var gravity_mult: float = 1.0 ## Multiples gravity for NEW foods
@export var spawn_speed_mult: float = 1.0 ## Less means more frequent spawns!
@export var spit_speed_mult: float = 1.0

var foods_on_spit: Array[Food] = [] ## Could just be array of enum...
var spawned_food_counter: int = 0 ## Updated by Food when it's added to tree
var order: Array[Food.Request] = []
var camera: ShakyCamera = null

var eat_available: bool = true
var _food_queue: Array[Food]

#region Player
var score: int = 0
#endregion


@onready var countdown_timer: Timer = $CountdownTimer
@onready var feed_event_timer: Timer = $FeedEventTimer


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	
	entire_spit_eaten.connect(func(): try_add_time())

func init_game() -> void:
	score = 0
	get_tree().create_timer(1).timeout.connect(start_game)

func _process(_delta: float) -> void:
	if not _food_queue.is_empty() and eat_available:
		_eat_food(_food_queue.pop_front())

func start_game() -> void:
	create_order()
	countdown_timer.start(game_time) 
	game_started.emit()
	game_running = true


## Called on countdown timer timeout
func end_game() -> void:
	game_ended.emit()
	game_running = false

#region georgisar
func is_order_satisfied() -> bool:
	return foods_on_spit.is_empty() and _food_queue.is_empty() and order.is_empty()

func try_add_time() -> void:
	if !is_order_satisfied():
		return
	
	countdown_timer.start(countdown_timer.time_left + 15)
#endregion

#region spit
## Called by Food when food is added to spit
func food_spitted(food: Food) -> void:
	var fx: FXManager.FX
	match food.type:
		Food.Type.MUSHROOM:
			fx = FXManager.FX.SPITTED_SHROOM
		Food.Type.PINEAPPLE:
			fx = FXManager.FX.SPITTED_PINE
		Food.Type.TOMATO:
			fx = FXManager.FX.SPITTED_TOMATO
		Food.Type.ZUCCHINI:
			fx = FXManager.FX.SPITTED_ZUCC
	FXManager.request_fx(fx)
	
	
	if not foods_on_spit.has(food):
		foods_on_spit.append(food)
	
	food_got_spitted.emit()


## Called by Food when food falls off spit
func food_fell_off(food: Food) -> void:
	if foods_on_spit.has(food):
		foods_on_spit.erase(food)


func spitted_food_count() -> int:
	return foods_on_spit.size()
#endregion

#region Feeding
func _eat_food(food: Food) -> void:
	var entire_eaten: bool = false
	
	if feed_event_timer.is_stopped():
		feed_event_timer.start(time_to_feed)
	FXManager.request_fx(FXManager.FX.EAT)
	## Is in order?
	var food_in_order: bool = false
	var req_index: int = 0
	for request: Food.Request in order:
		if is_food_in_request(food, request):
			food_in_order = true
			feed_combo += 1
			break
		req_index += 1
	
	## Taste test
	var review: Review = Review.TERRIBLY_COOKED
	if food_in_order:
		## How was it cooked
		if food.prepared == order[req_index].prepared:
			#print("amazing")
			calculate_and_add_score(food, Review.AMAZING)
			review = Review.AMAZING

		elif food.prepared + 1 == order[req_index].prepared or food.prepared - 1 == order[req_index].prepared:
			#print("decent")
			calculate_and_add_score(food, Review.DECENT)
			review = Review.DECENT

		else:
			#print("terribly cooked")
			review = Review.TERRIBLY_COOKED
			calculate_and_add_score(food, Review.TERRIBLY_COOKED)
		
		## Remove from order
		order[req_index].amount -= 1 ## Remove one amount from order
		if order[req_index].amount <= 0:
			order.remove_at(req_index)
			if order.is_empty():
				entire_eaten = true
		order_changed.emit()
	else:
		## Not in order at all!
		feed_combo = 0
		calculate_and_add_score(food, Review.WRONG_FOOD)
	
	
	food_eaten.emit(food, review)
	
	food.queue_free()
	
	eat_available = true


func request_eat_food(food: Food) -> void:
	_food_queue.append(food)


func calculate_and_add_score(food: Food, review: Review) -> void:
	var mult: float = 1.0
	var s: int = food.points
	match review:
		Review.AMAZING:
			mult = review_mult * 12
		Review.DECENT:
			mult = review_mult * 6
		Review.TERRIBLY_COOKED:
			mult = review_mult * 3
		Review.WRONG_FOOD:
			mult = 1.0
		_:
			pass ## Error!
	
	
	s = int(float(s) * mult)
	add_score(s)


func wrap_up_eat_phase() -> void:
	#apply_combo_mult_to_score()
	entire_spit_eaten.emit()


## Called on FeedEventTimer timeout (function way down here)
func end_feeding() -> void:
	#if _food_queue.is_empty() and foods_on_spit.is_empty():
	wrap_up_eat_phase()
	feed_combo = 0


func add_score(gained: int, multiply: bool = false) -> void:
	if not multiply:
		score += gained
		score_added.emit(gained)
	else:
		var old_score: int = score
		score *= gained
		combo_mult_applied.emit()
		#score_added.emit(score - old_score)
	print(score)


#func apply_combo_mult_to_score() -> void:
	#var actual_feed_combo: int = feed_combo if feed_combo > 0 else 1
	#add_score(actual_feed_combo, true)
	
#endregion

#region Order
func create_order() -> void:
	var new_order: Array[Food.Request]
	var foods_in_order: int = 0
	for r: int in randi_range(1, 4):
		for attempt: int in 40:
			if foods_in_order >= max_order_size:
				break
			
			var ingredient: int = randi_range(0, Food.Type.size()-1)
			var is_used: bool = false
			for request: Food.Request in new_order:
				if request.type == ingredient:
					is_used = true
					break
			if not is_used:
				var request: Food.Request = Food.Request.rnd_request(ingredient, max_order_size-foods_in_order)
				foods_in_order += request.amount
				new_order.append(request)
				break
	if new_order.is_empty():
		new_order.append(Food.Request.rnd_request())
	
	order = new_order
	
	print(order)
	for r: Food.Request in order:
		print("%s, %s, %d" % [Food.Type.keys()[r.type], Food.Prepared.keys()[r.prepared], r.amount])
	
	order_created.emit()

func is_food_in_request(food: Food, request: Food.Request) -> bool:
	if food.type == request.type:
		if request.amount > 0:
			return true
	return false


func is_food_in_order(food: Food) -> bool:
	for request: Food.Request in order:
		if is_food_in_request(food, request):
			return true
	return false
#endregion


func _on_countdown_timer_timeout() -> void:
	timer_finished.emit()
	end_game()


func _on_feed_event_timer_timeout() -> void:
	end_feeding()
