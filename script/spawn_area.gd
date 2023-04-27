class_name SpawnArea
extends Area2D


@export_node_path("CollisionShape2D") var _body_path: NodePath

@export var _pickup_scene: PackedScene

@onready var _body: CollisionShape2D = get_node(_body_path)

var _timings: Array[MusicTiming.Timing]


func init(timings: Array[MusicTiming.Timing]) -> void:
	self._timings = timings


func check_timing(current_timing: float) -> void:
	if _timings.size() <= 0 or _timings[0].value > current_timing:
		return
	
	var timing: MusicTiming.Timing = _timings.pop_front()
	if timing.type == MusicTiming.TimingType.PICKUP:
		spawn_pickup(timing.position)


func spawn_pickup(_position: float) -> void:
	var half_size: float = _body.shape.get_rect().size.x / 2.0
	
	var pickup: Pickup = _pickup_scene.instantiate()
	pickup.position.x += half_size * _position
	add_child(pickup)
