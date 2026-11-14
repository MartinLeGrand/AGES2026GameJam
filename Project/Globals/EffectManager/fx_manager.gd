extends Node

const BASE_MULT: float = 1.0

@export var reset_time: float = 0.5
@export var combo_increment: float = 0.2

@export_category("Eat")
@export var eat_pause: float = 0.7

var combo_mult: float = BASE_MULT


@onready var crunch_sound: AudioStreamPlayer = $CrunchSound
@onready var reset_timer: Timer = $ResetTimer


func play_eat() -> void:
	get_tree().paused = true
	crunch_sound.pitch_scale = combo_mult
	crunch_sound.play()
	await get_tree().create_timer(eat_pause / combo_mult).timeout
	get_tree().paused = false
	
	_add_to_combo()


func _add_to_combo() -> void:
	combo_mult += combo_increment
	reset_timer.start(reset_time)

func _on_reset_timer_timeout() -> void:
	combo_mult = BASE_MULT
