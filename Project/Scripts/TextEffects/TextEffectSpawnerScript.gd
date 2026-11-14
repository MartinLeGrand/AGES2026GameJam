extends Node2D

func spawnTextEffect(effect: PackedScene):
	var new_effect := effect.instantiate() as TextEffect
	
	add_child(new_effect)
