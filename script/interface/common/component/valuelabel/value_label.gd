class_name ValueLabel
extends HBoxContainer


@export_node_path("Label") var _text_label_path: NodePath
@export_node_path("Label") var _value_label_path: NodePath

@export var _value_change_duration: float

@onready var _text_label: Label = get_node(_text_label_path)
@onready var _value_label: Label = get_node(_value_label_path)

@export var text: String


var value: int:
	get:
		return value
	set(new_value):
		var change: int = new_value - value
		if _value_change_duration == 0 or abs(change) == 1:
			value = new_value
			_on_tween_set_value(value)
		elif change != 0:
			var _tween: Tween = create_tween()
			_tween.tween_method(_on_tween_set_value, value, new_value, _value_change_duration)
			value = new_value


func _ready() -> void:
	self.value = 0
	self._text_label.text = str(text)


func _on_tween_set_value(new_value: int) -> void:
	_value_label.text = str(new_value)
