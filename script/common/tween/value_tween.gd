class_name ValueTween
extends Node


signal finished
signal updated(value)


@export var _duration: float
@export var _delta: float

var value: float:
	get:
		return value
	set(new_value):
		if value != new_value:
			value = new_value
			emit_signal("updated", value)


func start(_value: float) -> void:
	var _tween: Tween = create_tween()
	value = _value
	_tween.tween_property(self, "value", value + _delta, _duration)
	await _tween.finished
	emit_signal("finished")
