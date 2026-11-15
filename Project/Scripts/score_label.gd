extends Label

func _ready() -> void:
	text = "Score: %s" % GameManager.score
