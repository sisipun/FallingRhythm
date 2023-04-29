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
	self._last_timing_value = -1.0 if timings.is_empty() else timings[0].value
	self._half_body_size = _body.shape.get_rect().size.x / 2.0


func check_timing(current_timing: float) -> void:
	if _last_timing_value < 0 or _last_timing_value > current_timing:
		return
	
	var timing: MusicTiming.Timing = _timings.pop_front()
	spawn_pickup(timing.position)
	
	_last_timing_value = -1.0 if _timings.is_empty() else _timings[0].value


func spawn_pickup(_position: float) -> void:
	var pickup: Pickup = _pickup_scene.instantiate()
	add_child(pickup)
	pickup.init(pickup_velocity, _half_body_size * _position)
