class_name Countdown
extends Node


signal finished
signal updated(value)


@export var _duration: int

var value: int:
	get:
		return value
	set(new_value):
		if value != new_value:
			value = new_value
			emit_signal("updated", value + 1)


func start() -> void:
	var _tween: Tween = create_tween()
	value = _duration
	_tween.tween_property(self, "value", 0, _duration)
	await _tween.finished
	emit_signal("finished")
