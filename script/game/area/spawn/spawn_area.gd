class_name SpawnArea
extends Area2D


signal pickup_caught(pickup)
signal pickup_lost(pickup)


@export_node_path("CollisionShape2D") var _body_path: NodePath
@export_node_path("Node2D") var _pickups_path: NodePath

@export var _pickup_scene: PackedScene
@export var _pickup_line_scene: PackedScene
@export_range(0, 10000) var pickup_velocity: float

@onready var _body: CollisionShape2D = get_node(_body_path)
@onready var _pickups: Node2D = get_node(_pickups_path)

var _timings: Array[SongTiming.Timing]
var _last_timing_value: float
var _half_body_size: float


func init(timings: Array[SongTiming.Timing]) -> void:
	self._timings = timings
	self._last_timing_value = -1.0 if timings.is_empty() else timings[0].start_second
	self._half_body_size = _body.shape.size.x * _body.global_scale.x / 2.0


func check_timing(current_timing: float) -> void:
	if _last_timing_value < 0 or _last_timing_value > current_timing:
		return
	
	var timing: SongTiming.Timing = _timings.pop_front()
	var pickup_position: float = _half_body_size * timing.position
	if timing.type == SongTiming.TimingType.PICKUP:
		var pickup: Pickup = spawn_pickup(_pickup_scene)
		pickup.init(pickup_velocity, pickup_position)
	elif timing.type == SongTiming.TimingType.PICKUP_LINE:
		var length: float = pickup_velocity * timing.duration
		var pickup: PickupLine = spawn_pickup(_pickup_line_scene)
		pickup.init(pickup_velocity, pickup_position, length, _pickup_scene)
	
	_last_timing_value = -1.0 if _timings.is_empty() else _timings[0].start_second


func spawn_pickup(_scene: PackedScene) -> BasePickup:
	var pickup: BasePickup = _scene.instantiate()
	_pickups.add_child(pickup)
	pickup.caught.connect(Callable(_on_pickup_caught).bind(pickup))
	pickup.lost.connect(Callable(_on_pickup_lost).bind(pickup))
	return pickup


func clear_pickups() -> void:
	for pickup in _pickups.get_children():
		_pickups.remove_child(pickup)
		pickup.queue_free()


func _on_pickup_caught(pickup: BasePickup) -> void:
	emit_signal("pickup_caught", pickup)


func _on_pickup_lost(pickup: BasePickup) -> void:
	emit_signal("pickup_lost", pickup)
