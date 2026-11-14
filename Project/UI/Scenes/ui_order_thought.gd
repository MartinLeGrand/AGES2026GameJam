extends Control

func _ready() -> void:
	GameManager.order_created.connect(_on_order_created)
	
	# behövs för att gamemanager skapar första ordern innan uien ens hinner instantiata.
	if not GameManager.order.is_empty():
		_on_order_created()

func _on_order_created() -> void:
	for child in $TextureRect/GridContainer.get_children():
		child.queue_free()
	print_debug("Order Received")
	for request in GameManager.order:
		var requestItem = OrderItem.new()
		requestItem.setFoodType(request.type)
		requestItem.setTargetPrepared(request.prepared)
		$TextureRect/GridContainer.add_child(requestItem)
