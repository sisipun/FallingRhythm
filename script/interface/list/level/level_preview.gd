class_name LevelPreview
extends ColorRect


@export_node_path("Label") var _level_name_path: NodePath

@onready var _level_name: Label = get_node(_level_name_path)

var music_id: String


func init(_music_id: String) -> void:
	self.music_id = _music_id
	_level_name.text = music_id


func _gui_input(event: InputEvent):
	if event is InputEventScreenTouch and event.is_pressed():
		EventStorage.emit_signal("level_change_request", music_id)
