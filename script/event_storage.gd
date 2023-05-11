extends Node


# LEVEL
signal level_finished(music_id, score)
signal level_started(music_id)
signal level_score_updated(music_id, score)
signal level_paused(music_id)
signal level_resumed(music_id)

signal level_start_request
signal level_pause_request
signal level_resume_request
