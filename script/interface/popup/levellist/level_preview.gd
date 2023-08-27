class_name LevelPreview
extends Panel


signal pressed


@export_node_path("Label") var _level_name_path: NodePath

@export_color_no_alpha var _selected_color: Color
@export_color_no_alpha var _unselected_color: Color

# TODO get_theme_stylebox()
@export var _style: StyleBoxFlat

@onready var _level_name: Label = get_node(_level_name_path)

var song_id: String
var _override_style: StyleBoxFlat


func _ready() -> void:
	_override_style = _style.duplicate()
	add_theme_stylebox_override("panel", _override_style)


func init(_song_id: String) -> void:
	self.song_id = _song_id
	_level_name.text = song_id


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		emit_signal("pressed")


func select() -> void:
	_override_style.bg_color = _selected_color


func unselect() -> void:
	_override_style.bg_color = _unselected_color
