class_name LevelList
extends VBoxContainer


@export var level_preview_scene: PackedScene


func _ready() -> void:
	for song_timing in SongStorage.song_timings:
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		add_child(level_preview)
		level_preview.init(song_timing.id)
		level_preview.pressed.connect(Callable(_on_level_pressed).bind(level_preview))


func _on_level_pressed(preview: LevelPreview) -> void:
	EventStorage.emit_signal("level_start_request", preview.song_id)
