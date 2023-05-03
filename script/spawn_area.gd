class_name SpawnArea
extends Area2D


@export_node_path("CollisionShape2D") var _body_path: NodePath

@export var _pickup_scene: PackedScene
@export_range(0, 10000) var pickup_velocity: float

@onready var _body: CollisionShape2D = get_node(_body_path)

var _timings: Array[MusicTiming.Timing]
var _last_timing_value: float
var _half_body_size: float


func init(timings: Array[MusicTiming.Timing]) -> void:
	self._timings = timings
	self._last_timing_value = -1.0 if timings.is_empty() else timings[0].start_second
	self._half_body_size = _body.shape.size.x * _body.global_scale.x / 2.0


func check_timing(current_timing: float) -> void:
	if _last_timing_value < 0 or _last_timing_value > current_timing:
		return
	
	var timing: MusicTiming.Timing = _timings.pop_front()
	if timing.type == MusicTiming.TimingType.PICKUP:
		spawn_pickup(timing.position)
	elif timing.type == MusicTiming.TimingType.PICKUP_LINE:
		var length: float = pickup_velocity * timing.duration
		spawn_pickup_line(timing.position, length)
	
	_last_timing_value = -1.0 if _timings.is_empty() else _timings[0].start_second


func spawn_pickup(_position: float) -> void:
	var pickup: Pickup = _pickup_scene.instantiate()
	add_child(pickup)
	pickup.init(pickup_velocity, _half_body_size * _position)


func spawn_pickup_line(_position: float, _length: float) -> void:
	var denormalized_position: float = _half_body_size * _position
	var pickup: Pickup = _pickup_scene.instantiate()
	add_child(pickup)
	pickup.init(pickup_velocity, denormalized_position)

	var spawn_count: int = int(_length / pickup.half_body_size) - 1
	for i in range(spawn_count):
		pickup = _pickup_scene.instantiate()
		add_child(pickup)
		pickup.init(pickup_velocity, denormalized_position, i + 1)
