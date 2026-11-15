class_name Chomper extends Node3D

@export var croc_top: Node3D
@export var croc_bottom: Node3D

@export var jaw_open_time: float = 1.0
@export var jaw_close_time: float = 0.7

var start_y: float = 0.0
var 

func _ready() -> void:
	GameManager.order_created.connect(open_jaw)
	GameManager.entire_spit_eaten.connect(close_jaw)
	
	start_y = global_position.y
	
	var hover_tween : Tween = get_tree().create_tween()
	var angle_tween: Tween = get_tree().create_tween()
	
	hover_tween.set_loops(-1)
	angle_tween.set_loops(-1)
	
	hover_tween.tween_property(croc_top, "global_position:y", start_y + 0.4, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	hover_tween.tween_property(croc_top, "global_position:y", start_y, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	angle_tween.tween_property(croc_top, "global_rotation:z", deg_to_rad(3.0), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	angle_tween.tween_property(croc_top, "global_rotation:z", deg_to_rad(-3.0), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func open_jaw():
	print("open")
	get_tree().create_tween().tween_property(croc_top, "global_rotation:x", deg_to_rad(14.0), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	get_tree().create_tween().tween_property(croc_bottom, "global_rotation:x", deg_to_rad(-14.0), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close_jaw():
	get_tree().create_tween().tween_property(croc_top, "global_rotation:x", deg_to_rad(0.0), 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	get_tree().create_tween().tween_property(croc_bottom, "global_rotation:x", deg_to_rad(2.0), 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
