extends Label

var time_left: float = 0

func _process(delta: float) -> void:
	if GameManager.countdown_timer.is_stopped():
		text = get_formatted_time(GameManager.game_time)
	else:
		time_left = clampf(GameManager.countdown_timer.time_left, 0.0, INF)
		text = get_formatted_time(time_left)

func get_formatted_time(input_time: int):
	var minutes: int = floori(input_time / 60.0)
	var seconds: int = input_time % 60
	return "%02d:%02d" % [minutes, seconds]
