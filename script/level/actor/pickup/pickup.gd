class_name Pickup
extends BasePickup


func init(
	_spawn_second: float,
	_catch_second: float,
	_velocity: float,
	_position_x: float,
	_spawn_position_y: float,
	_catch_position_y: float
) -> void:
	super.base_init(
		_spawn_second,
		_catch_second,
		0,
		_velocity,
		Vector2(_position_x, _spawn_position_y),
		Vector2(_position_x, _catch_position_y),
		1
	)


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		has_caught = true
		emit_signal("caught")
		queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area is CatchArea and not has_caught:
		emit_signal("lost")
		queue_free()
