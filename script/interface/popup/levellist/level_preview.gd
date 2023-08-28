class_name LevelPreview
extends Panel


signal pressed


@export_node_path("Label") var _name_label_path: NodePath
@export_node_path("ValueLabel") var _best_score_label_path: NodePath

@export_color_no_alpha var _selected_color: Color
@export_color_no_alpha var _unselected_color: Color

@onready var _name_label: Label = get_node(_name_label_path)
@onready var _best_score_label: ValueLabel = get_node(_best_score_label_path)

var song_id: String
var _override_style: StyleBoxFlat


func _ready() -> void:
	var _style: StyleBoxFlat = get_theme_stylebox("panel", "")
	_override_style = _style.duplicate()
	add_theme_stylebox_override("panel", _override_style)


func init(_song_id: String, _best_score: int) -> void:
	self.song_id = _song_id
	_name_label.text = song_id
	_best_score_label.value = _best_score


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		emit_signal("pressed")


func select() -> void:
	_override_style.bg_color = _selected_color


func unselect() -> void:
	_override_style.bg_color = _unselected_color
