class_name OrderItem
extends TextureRect

@export var foodtype : Food.Type
var mushroomIcon : String = "res://Project/UI/Inkscape/Ingredient_Mushroom.png"
var pineappleIcon : String = "res://Project/UI/Inkscape/Ingredient_Pineapple.png"
var tomatoIcon : String = "res://Project/UI/Inkscape/Ingredient_Tomat.png"
var zucchiniIcon : String = "res://Project/UI/Inkscape/Ingredient_Zuchini.png"

#func _ready() -> void:
	#setFoodType(Food.Type.TOMATO)
	#setTargetPrepared(Food.Prepared.COOKED)

func setFoodType(food : Food.Type):
	foodtype = food
	if foodtype == Food.Type.MUSHROOM:
		texture = load(mushroomIcon)
	elif foodtype == Food.Type.PINEAPPLE:
		texture = load(pineappleIcon)
	elif foodtype == Food.Type.TOMATO:
		texture = load(tomatoIcon)
	elif foodtype == Food.Type.ZUCCHINI:
		texture = load(zucchiniIcon)

func setTargetPrepared(food : Food.Prepared):
	match food:
		Food.Prepared.RAW:
			print_debug("RAW")
			modulate = Color(1.0, 1.0, 1.0) # Normal
		Food.Prepared.MEDIUM_RARE:
			print_debug("RARE")
			modulate = Color(1.0, 0.85, 0.85) # Slightly warm
		Food.Prepared.COOKED:
			print_debug("COOKED")
			modulate = Color(0.85, 0.65, 0.65) # Darker, cooked look
		Food.Prepared.BURNT:
			print_debug("BURNT")
			modulate = Color(0.5, 0.25, 0.25) # Dark and reddish-brown
		Food.Prepared.COAL:
			print_debug("COAL")
			modulate = Color(0.2, 0.2, 0.2) # Charcoal dark gray
