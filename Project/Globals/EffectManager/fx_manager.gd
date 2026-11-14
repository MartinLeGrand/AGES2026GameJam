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
}

const SPITTED_SHROOM = preload("uid://d1lshd1msyf85")
const SPITTED_RANDOMIZER = preload("uid://cvvur8xb5k2xv")
const SPITTED_ZUCC = preload("uid://bx56j4pfw5yaq")
const SPITTED_TOMATO = preload("uid://da7gfv4moyhpl")

const BASE_MULT: float = 1.0

@export var reset_time: float = 0.5
@export var combo_increment: float = 0.2

@export_category("Eat")
@export var eat_pause: float = 0.7

var combo_mult: float = BASE_MULT
var _fx_queue: Array[FX] = []
var _fx_available: bool = true

@onready var reset_timer: Timer = $ResetTimer
@onready var crunch_sound: AudioStreamPlayer = $CrunchSound
@onready var spitted_sound: AudioStreamPlayer = $SpittedSound
@onready var bouncing_on_spit: AudioStreamPlayer = $BouncingOnSpit


## Freezes cam and plays audio
func _play_eat() -> void:
	_fx_available = false
	get_tree().paused = true
	GameManager.camera.add_trauma()
	screenshake_requested.emit()
	crunch_sound.pitch_scale = combo_mult
	crunch_sound.play()
	await get_tree().create_timer(eat_pause / combo_mult).timeout
	get_tree().paused = false
	_add_to_combo()
	_fx_available = true


func _play_spitted(type: FX) -> void:
	match type:
		FX.BOUNCE_ON_SPIT:
			GameManager.camera.add_trauma(0.1)
			bouncing_on_spit.play()
			return
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
			FX.EAT:
				_play_eat()
			_: 
				_play_spitted(fx)


func request_fx(fx: FX) -> void:
	_fx_queue.append(fx)


func request_screenshake() -> void:
	screenshake_requested.emit()


func _add_to_combo() -> void:
	combo_mult += combo_increment
	reset_timer.start(reset_time)


func _on_reset_timer_timeout() -> void:
	combo_mult = BASE_MULT
