class_name GameData
extends Node


var songs: Array[SongData]
var current_song_id: String


func _init(_songs: Array[SongData], _current_song_id: String) -> void:
	self.songs = _songs
	self.current_song_id = _current_song_id
