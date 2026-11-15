extends Node


signal screenshake_requested


## NOOO jag ville att denna enum skulle va bra men nu är det bara bajs :(
enum FX{
	EAT,
	BOUNCE_ON_SPIT,
	SPITTED_SHROOM,
	SPITTED_ZUCC,
	SPITTED_TOMATO,
	SPITTED_PINE,
	#START_COOKING,
	#STOP_COOKING,
	FORCED,
}

const FRYING_LOOP = preload("uid://b0cf30v31j0j7")

const SPITTED_SHROOM = preload("uid://d1lshd1msyf85")
const SPITTED_RANDOMIZER = preload("uid://cvvur8xb5k2xv")
const SPITTED_ZUCC = preload("uid://bx56j4pfw5yaq")
const SPITTED_TOMATO = preload("uid://da7gfv4moyhpl")

const BASE_MULT: float = 1.0

@export var reset_time: float = 0.5
@export var combo_increment: float = 0.2

@export_category("Eat")
@export var eat_pause: float = 0.4

var combo_mult: float = BASE_MULT
var _fx_queue: Array[FX] = []
var _forced_callables: Array[Callable] = []
var _fx_available: bool = true

var frying_poly_playback: AudioStreamPlaybackPolyphonic
var _playing_frying: Array[int] = []

@onready var reset_timer: Timer = $ResetTimer
@onready var crunch_sound: AudioStreamPlayer = $CrunchSound
@onready var spitted_sound: AudioStreamPlayer = $SpittedSound
@onready var bouncing_on_spit: AudioStreamPlayer = $BouncingOnSpit
@onready var empty_spit: AudioStreamPlayer = $EmptySpit

@onready var frying_sound: AudioStreamPlayer = $FryingSound


func _ready() -> void:
	frying_sound.play()
	frying_poly_playback = frying_sound.get_stream_playback()
	
	GameManager.feed_combo_reset.connect(reset_combo)

func _play_forced() -> void:
	_fx_available = false
	get_tree().paused = true
	GameManager.countdown_timer.paused = true
	await _forced_callables.pop_front().call()
	GameManager.countdown_timer.paused = false
	get_tree().paused = false
	_fx_available = true


func play_empty_spit() -> void:
	if not empty_spit.playing:
		empty_spit.play()


## Freezes cam and plays audio
func _play_eat() -> void:
	_fx_available = false
	get_tree().paused = true
	GameManager.camera.add_trauma()
	screenshake_requested.emit()
	crunch_sound.pitch_scale = combo_mult
	crunch_sound.play()
	GameManager.countdown_timer.paused = true
	await get_tree().create_timer(eat_pause / combo_mult).timeout
	GameManager.countdown_timer.paused = false
	get_tree().paused = false
	_add_to_combo()
	_fx_available = true


func _play_spitted(type: FX) -> void:
	match type:
		FX.BOUNCE_ON_SPIT:
			GameManager.camera.add_trauma(0.1)
			bouncing_on_spit.play()
			return
		#FX.START_COOKING:
			#play_a_frying_sound()
			#return
		#FX.STOP_COOKING:
			#stop_a_frying_sound()
			#return
		FX.SPITTED_SHROOM:
			spitted_sound.stream = SPITTED_SHROOM
		FX.SPITTED_ZUCC:
			spitted_sound.stream = SPITTED_ZUCC
		FX.SPITTED_TOMATO:
			spitted_sound.stream = SPITTED_TOMATO
		_:
			spitted_sound.stream = SPITTED_RANDOMIZER
			
	GameManager.camera.add_trauma()
	spitted_sound.play()


func _process(delta: float) -> void:
	if not _fx_queue.is_empty() and _fx_available:
		var fx: FX = _fx_queue.pop_front()
		match fx:
			FX.FORCED:
				_play_forced()
			FX.EAT:
				_play_eat()
			_: 
				_play_spitted(fx)
	
	## Förlåt för detta. Det är för att stoppa bugg som gör att den playar hela tiden
	## Play fry sound :()
	var frying_food: = 0
	for food: Food in GameManager.foods_on_spit:
		if food.is_speared and food.over_fire:
			frying_food += 1
	var pf: = _playing_frying.size()
	if frying_food > pf:
		play_a_frying_sound()
	elif frying_food < pf:
		stop_a_frying_sound()


func request_fx(fx: FX, force_first: bool = false) -> void:
	if force_first:
		_fx_queue.insert(0, fx)
	else:
		_fx_queue.append(fx)


func callable_fx(fx_callable: Callable, force: bool = false) -> void:
	_forced_callables.append(fx_callable)
	request_fx(FX.FORCED, force)


func request_screenshake() -> void:
	screenshake_requested.emit()


func _add_to_combo() -> void:
	combo_mult += combo_increment
	reset_timer.start(reset_time)


func reset_combo() -> void:
	print("RESET!")
	combo_mult = BASE_MULT

func _on_reset_timer_timeout() -> void:
	reset_combo()


func play_a_frying_sound() -> void:
	_playing_frying.append(frying_poly_playback.play_stream(FRYING_LOOP, randf_range(0, FRYING_LOOP.get_length()))) 


func stop_a_frying_sound() -> void:
	if _playing_frying.is_empty():
		return
	frying_poly_playback.stop_stream(_playing_frying.pop_front())
