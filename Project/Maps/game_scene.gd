extends Node3D


@onready var ui_order_thought: Control = $CanvasLayerForeground/UiOrderThought

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.init_game()
	GameManager.game_started.connect(ui_order_thought.show)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
