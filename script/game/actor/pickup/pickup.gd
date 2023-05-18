class_name Pickup
extends BasePickup


func init(_velocity: float, _position_x: float, _position_y: float = 0) -> void:
	super.base_init(_velocity, Vector2(_position_x, _position_y), 1)


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		has_caught = true
		emit_signal("caught")
		queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area is CatchArea and not has_caught:
		emit_signal("lost")
		queue_free()
