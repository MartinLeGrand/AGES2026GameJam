extends Control
var animPlayer : AnimationPlayer

func _ready() -> void:
	animPlayer = $AnimationPlayer


func start_mainmenu_loop() -> void:
	animPlayer.play("anim_mainmenu_loop")


func _on_button_pressed() -> void:
	animPlayer.play("anim_mainmenu_gamestart")
	print_debug("Start Game")

func _on_button_2_pressed() -> void:
	animPlayer.play("anim_mainmenu_quit")
	print_debug("Quit Game")

func start_game() -> void:
	get_tree().change_scene_to_packed(preload("uid://bk7m2ifpl8vbh"))

func quit_game() -> void:
	get_tree().quit()

func fade_master_to_zero(duration: float = 1.0) -> void:
	var master_index = AudioServer.get_bus_index("Master")
	var start_volume = AudioServer.get_bus_volume_db(master_index)
	
	var tween = create_tween()
	tween.tween_method(
		func(vol: float): AudioServer.set_bus_volume_db(master_index, vol),
		start_volume,
		0.0,
		duration
	)
