class_name HomeInterface
extends Control


func _ready() -> void:
	EventStorage.level_change_request.connect(_on_level_change_request)


func _on_level_change_request(song_id: String) -> void:
	EventStorage.emit_signal("scene_switch_level", song_id)
