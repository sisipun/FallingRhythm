class_name LevelList
extends VBoxContainer


@export var level_preview_scene: PackedScene


func _ready() -> void:
	for song_timing in SongStorage.song_timings:
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		add_child(level_preview)
		level_preview.init(song_timing.id)
