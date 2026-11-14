class_name PrototypeFood extends Node3D

var velocity: Vector3 = Vector3.ZERO
var spin_rate: float = 0.0
var skewered: bool = false

func _ready() -> void:
	spin_rate = randf_range(2, 8)
	
	velocity.x = randf_range(-2, 2)

func _process(delta: float) -> void:
	if skewered:
		return
	
	rotate(Vector3.FORWARD, spin_rate * delta)
	
	velocity.y -= 6.0 * delta
	
	global_translate(velocity * delta)

func skewer(attacher: Node3D):
	skewered = true
	
	reparent(attacher)
