class_name Chomper extends Node3D

@export var croc_top: Node3D
@export var croc_bottom: Node3D

@export var jaw_open_time: float = 1.0
@export var jaw_close_time: float = 0.7

var start_y: float = 0.0
var target_rot_top: float = 0.0
var target_rot_bottom: float = 0.0

func _ready() -> void:
	GameManager.order_created.connect(open_jaw)
	GameManager.entire_spit_eaten.connect(close_jaw)
	
	start_y = global_position.y
	
	var hover_tween : Tween = get_tree().create_tween()
	var angle_tween: Tween = get_tree().create_tween()
	
	hover_tween.set_loops(-1)
	angle_tween.set_loops(-1)
	
	hover_tween.tween_property(self, "global_position:y", start_y + 0.4, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	hover_tween.tween_property(self, "global_position:y", start_y, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	angle_tween.tween_property(self, "global_rotation:z", deg_to_rad(3.0), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	angle_tween.tween_property(self, "global_rotation:z", deg_to_rad(-3.0), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(delta: float) -> void:
	croc_top.global_rotation_degrees.x = lerp(croc_top.global_rotation_degrees.x, target_rot_top, 2.0 * delta)
	croc_bottom.global_rotation_degrees.x = lerp(croc_bottom.global_rotation_degrees.x, target_rot_bottom, 2.0 * delta)

func open_jaw():
	target_rot_top = 14.0
	target_rot_bottom = -14.0
	
	#get_tree().create_tween().tween_property(croc_top, "global_rotation_degrees:x", 14.0, 1.0).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	#get_tree().create_tween().tween_property(croc_bottom, "global_rotation_degrees:x", -14.0, 1.0).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)

func close_jaw():
	print("Closing!")
	
	target_rot_top = 0.0
	target_rot_bottom = 2.0
	
	#get_tree().create_tween().tween_property(croc_top, "global_rotation_degrees:x", 0.0, 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	#get_tree().create_tween().tween_property(croc_bottom, "global_rotation_degrees:x", 2.0, 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
