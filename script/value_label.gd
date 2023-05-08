class_name ValueLabel
extends HBoxContainer


@export_node_path("Label") var _text_label_path: NodePath
@export_node_path("Label") var _value_label_path: NodePath

@onready var _text_label: Label = get_node(_text_label_path)
@onready var _value_label: Label = get_node(_value_label_path)

@export var text: String


var value: int:
	get:
		return value
	set(_value):
		value = _value
		_value_label.text = str(value)


func _ready() -> void:
	self.value = 0
	self._text_label.text = str(text)
