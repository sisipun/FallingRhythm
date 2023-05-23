extends Node


@export var song_timings: Array[SongTiming]

var _timings: Dictionary = {}
var _best_score: Dictionary = {}


func _ready() -> void:
	EventStorage.game_updated.connect(_on_game_updated)
	EventStorage.game_best_score_updated.connect(_on_game_best_score_updated)
	
	for song_timing in song_timings:
		_timings[song_timing.id] = song_timing
		_best_score[song_timing.id] = 0


func get_song_timing(song_id: String) -> SongTiming:
	return _timings[song_id]


func get_best_score(song_id: String) -> int:
	return _best_score[song_id]


func _on_game_updated(game: GameData) -> void:
	for song in game.songs:
		_best_score[song.id] = song.best_score


func _on_game_best_score_updated(song_id: String, score: int) -> void:
	_best_score[song_id] = score
