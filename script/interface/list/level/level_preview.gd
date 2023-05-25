class_name LevelPreview
extends ColorRect


@export_node_path("Label") var _level_name_path: NodePath

@onready var _level_name: Label = get_node(_level_name_path)

var song_id: String


func init(_song_id: String) -> void:
	self.song_id = _song_id
	_level_name.text = song_id


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		EventStorage.emit_signal("level_change_request", song_id)
