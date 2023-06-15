class_name GameDataParser
extends Node


static func write(game: GameData) -> Dictionary:
	var songs: Array[Dictionary] = []
	for song in game.songs:
		songs.push_back(SongDataParser.write(song))
	return {
		"songs": songs,
		"current_song_id": game.current_song_id
	}


static func read(dict: Dictionary) -> GameData:
	var songs: Array[SongData] = []
	for song in dict["songs"]:
		songs.push_back(SongDataParser.read(song))
	return GameData.new(
		songs,
		dict["current_song_id"]
	)
