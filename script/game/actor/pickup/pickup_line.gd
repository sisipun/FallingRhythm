class_name PickupLine
extends BasePickup


var _pickups: Array[Pickup] = []


func init(
	_start_second: float, 
	_duration: float, 
	_velocity: float, 
	_position_x: float, 
	_length: float, 
	_pickup_scene: PackedScene
) -> void:
	var first_pickup: Pickup = _spawn_pickup(_pickup_scene, 0)
	var pickup_offset: float = first_pickup.body_size
	super.base_init(
		_start_second, 
		_duration, 
		_velocity, 
		Vector2(_position_x, 0), 
		int(_length / pickup_offset) - 1
	)
	
	for i in range(score):
		_spawn_pickup(_pickup_scene, (i + 1) * -pickup_offset)
	
	var last_pick_up: Pickup = _pickups[-1]
	var pickups_distance: float = first_pickup.position.y - last_pick_up.position.y
	_body.position.y = -pickups_distance / 2
	_body.shape.size.x = first_pickup.body_size
	_body.shape.size.y = pickups_distance


func _spawn_pickup(
	_pickup_scene: PackedScene, 
	_position_y: float
) -> Pickup:
	var pickup: Pickup = _pickup_scene.instantiate()
	add_child(pickup)
	pickup.init(start_second, 0, 0, _position_y)
	pickup.caught.connect(Callable(_on_pickup_caught).bind(pickup))
	pickup.lost.connect(Callable(_on_pickup_lost).bind(pickup))
	_pickups.push_back(pickup)
	return pickup


func _on_pickup_caught(pickup: Pickup) -> void:
	_pickups.erase(pickup)
	if _pickups.size() == 0:
		has_caught = true
		emit_signal("caught")
		queue_free()
	else:
		pickup.queue_free()


func _on_pickup_lost(pickup: Pickup) -> void:
	if _pickups.has(pickup) and not has_caught:
		emit_signal("lost")
		queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area is Player and not has_caught:
		emit_signal("lost")
		queue_free()
