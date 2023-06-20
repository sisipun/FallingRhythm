extends Node


@export var _save_path: String
@export var _save_file: String
@export var _current_version: String

var game: GameData = GameData.new([], "") 


func _ready() -> void:
	EventStorage.level_completed.connect(_on_level_completed)
	EventStorage.level_started.connect(_on_level_started)
	
	if not FileAccess.file_exists(_save_path + _save_file):
		EventStorage.emit_signal("game_updated", game)
		return
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	var version: String = data["version"]
	if version == _current_version:
		game = GameDataParser.read(data)
	
	EventStorage.emit_signal("game_updated", game)


func _on_level_started(song_id: String) -> void:
	game.current_song_id = song_id
	save()
	EventStorage.emit_signal("game_updated", game)


func _on_level_completed(song_id: String, score: int) -> void:
	var songs = game.songs.filter(func(song): return song.id == song_id)
	if songs.size() == 0:
		game.songs.push_back(SongData.new(song_id, score))
		save()
		EventStorage.emit_signal("game_best_score_updated", song_id, score)
	elif songs.size() != 0 && songs[0].best_score < score:
		songs[0].best_score = score
		save()
		EventStorage.emit_signal("game_best_score_updated", song_id, score)


func save() -> void:
	if not DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_absolute(_save_path)
		
	var data: Dictionary = GameDataParser.write(game)
	data["version"] = _current_version
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
