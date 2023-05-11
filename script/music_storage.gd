extends Node


@export var music_timings: Array[MusicTiming]

var _best_score: Dictionary = {}


func _ready() -> void:
	EventStorage.level_finished.connect(_on_level_finished)
	for music_timing in music_timings:
		_best_score[music_timing.id] = 0


func get_best_score(music_id: String) -> int:
	return _best_score[music_id]


func _on_level_finished(music_id: String, score: int) -> void:
	_best_score[music_id] = max(_best_score[music_id], score)
