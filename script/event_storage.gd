extends Node

# SCENE
signal scene_switch_home
signal scene_switch_level(music_id)

# LEVEL
signal level_finished(music_id, score)
signal level_started(music_id)
signal level_pickup_caught(pickup)
signal level_pickup_lost(pickup)
signal level_score_updated(score)
signal level_score_multiplier_updated(score_multiplier)
signal level_paused
signal level_resumed

signal level_start_request(music_id)
signal level_restart_request
signal level_pause_request
signal level_resume_request

# HOME
signal level_change_request(music_id)
