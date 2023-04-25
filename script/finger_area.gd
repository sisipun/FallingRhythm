class_name FingerArea
extends Area2D


signal pickup_caught(pickup)
signal pickup_lost(pickup)


@export_node_path("CatchArea") var _catch_area_path: NodePath

@onready var _catch_area: CatchArea = get_node(_catch_area_path)

var touch_event_index: int = -1


func _ready() -> void:
	_catch_area.pickup_caught.connect(_on_pickup_caught)
	_catch_area.pickup_lost.connect(_on_pickup_lost)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed() and touch_event_index == -1:
		touch_event_index = event.index


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and touch_event_index == event.index and not event.is_pressed():
		touch_event_index = -1
	elif event is InputEventScreenDrag and touch_event_index == event.index:
		_catch_area.move_player(event.relative.x)


func _on_pickup_caught(pickup: Pickup) -> void:
	emit_signal("pickup_caught", pickup)


func _on_pickup_lost(pickup: Pickup) -> void:
	emit_signal("pickup_lost", pickup)
