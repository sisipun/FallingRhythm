class_name LevelList
extends VBoxContainer


@export var level_preview_scene: PackedScene


func _ready() -> void:
	for music_timing in MusicStorage.music_timings:
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		add_child(level_preview)
		level_preview.init(music_timing.id)
