extends Control


#signal finsihed_showing_score



var shown_score: int = 0

var added_score: int = 0
var total_show_score: int = 0

var score_tween: Tween
var mult_tween: Tween
var get_final_score_tween: Tween

@onready var points_from_spit_label: Label = $PointsFromSpitLabel
@onready var combo_label: Label = $ComboPivot/ComboLabel
@onready var combo_pivot: Control = $ComboPivot
@onready var total_score_label: Label = $TotalScoreLabel


func _ready() -> void:
	GameManager.food_eaten.connect(_on_food_eaten)
	GameManager.order_created.connect(_on_order_created)
	GameManager.score_added.connect(_on_score_added)
	GameManager.feed_combo_gain.connect(_on_feed_combo_gain)
	GameManager.feed_combo_reset.connect(_on_feed_combo_reset)
	#GameManager.combo_mult_applied.connect(_on_combo_mult_applied)
	GameManager.entire_spit_eaten.connect(_on_entire_spit)
	

func _late_init() -> void:
	pass

#func emit_finsihed_showing_score() -> void:
	#finsihed_showing_score.emit()
	


func _on_order_created() -> void:
	shown_score = 0
	points_from_spit_label.hide()

func _on_food_eaten(_food: Food, _review) -> void:
	points_from_spit_label.show()

func _on_score_added(_gained: int) -> void:
	added_score = _gained
	FXManager.callable_fx(tween_score_added.bind(points_from_spit_label))
	#points_from_spit_label.text = "%06d" % GameManager.score


func _on_entire_spit() -> void:
	FXManager.callable_fx(tween_entire_spit)


func tween_entire_spit() -> Signal:
	if score_tween:
		score_tween.kill()
	if get_final_score_tween:
		get_final_score_tween.kill()

	get_final_score_tween = create_tween()
	get_final_score_tween.finished.connect(GameManager.create_order)
	
	get_final_score_tween.set_parallel()
	get_final_score_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	get_final_score_tween.tween_method(
		_update_score_label.bind(points_from_spit_label),
		float(shown_score),
		float(0),
		0.5
	)
	get_final_score_tween.tween_method(
		_update_score_label.bind(total_score_label),
		float(total_show_score),
		float(GameManager.score),
		0.5
	)
	
	return get_final_score_tween.finished

	

func _on_feed_combo_gain() -> void:
	combo_label.text = "Combo: x%d" % GameManager.feed_combo
	#combo_label.show()
	#FXManager.callable_fx(tween_mult_added.bind(combo_pivot))


func _on_feed_combo_reset() -> void:
	#combo_label.hide()
	combo_label.text = "Combo: x1"
	combo_label.self_modulate = Color.WHITE
	combo_label.scale = Vector2.ONE


func _on_combo_mult_applied() -> void:
	#FXManager.callable_fx(tween_combo_mult.bind(points_from_spit_label))
	pass


#func tween_mult_added(node: Control) -> Signal:
	#var duration: float = 0.2
	#if mult_tween:
		#mult_tween.kill()
	#mult_tween = create_tween()
	#
	#mult_tween.set_parallel()
	#mult_tween.set_trans(Tween.TRANS_BOUNCE)
	#mult_tween.tween_property(combo_label, "scale", scale, duration).from(Vector2(1.5, 1.5))
	##tween.tween_property(combo_label, "rotation_degrees", rot, duration).from(rot + randf_range(-10, 10))
	#return mult_tween.finished


func tween_score_added(label: Label) -> Signal:
	if score_tween:
		score_tween.kill()
	
	score_tween = create_tween()
	score_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	score_tween.tween_method(
		_update_score_label.bind(label),
		float(shown_score),
		float(shown_score + added_score),
		0.2
	)
	return score_tween.finished

#
#func tween_combo_mult(label: Label) -> Signal:
	##tween_mult_added(combo_pivot)
	#if score_tween:
		#score_tween.kill()
	#
	#score_tween = create_tween()
	#score_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	#score_tween.tween_method(
		#_update_score_label.bind(label),
		#float(shown_score),
		#float(GameManager.score),
		#3
	#)
	#return score_tween.finished
#

func _update_score_label(value: float, label: Label) -> void:
	shown_score = roundi(value)
	label.text = "%06d" % shown_score
