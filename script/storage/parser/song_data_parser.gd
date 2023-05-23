class_name SongDataParser
extends Node


static func write(song: SongData) -> Dictionary:
	return {
		"id" : song.id,
		"best_score" : song.best_score,
	}



static func read(dict: Dictionary) -> SongData:
	return SongData.new(
		dict["id"], 
		dict["best_score"], 
	)
