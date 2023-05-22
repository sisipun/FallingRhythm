class_name PowerBar
extends TextureProgressBar


@export var _min_progress_color: Color
@export var _max_progress_color: Color
@export var _progress_change_duration: float

var _current_value: float


func _ready() -> void:
	tint_progress = _min_progress_color
	_current_value = 0.0


func _set(field_name: StringName, new_value: Variant):
	if field_name == "value" and _current_value != new_value:
		var _tween: Tween = create_tween()
		_tween.tween_method(_on_tween_set_value, _current_value, new_value, _progress_change_duration)
		_current_value = new_value


func _on_tween_set_value(new_value: float) -> void:
	value = new_value
	tint_progress = lerp(_min_progress_color, _max_progress_color, new_value / max_value)
