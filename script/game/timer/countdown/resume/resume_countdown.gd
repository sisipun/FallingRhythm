class_name ResumeCountdown
extends Node


signal finished
signal updated(value)


@export var _duration: int

var _value: int:
	get:
		return _value
	set(new_value):
		if _value != new_value:
			_value = new_value
			emit_signal("updated", _value + 1)


func start() -> void:
	var _tween: Tween = create_tween()
	_value = _duration
	_tween.tween_property(self, "_value", 0, _duration)
	await _tween.finished
	emit_signal("finished")
