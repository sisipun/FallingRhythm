extends Node

# GAME
signal game_updated(game)
signal game_best_score_updated(song_id, score)

# SCENE
signal scene_switch_home
signal scene_switch_level(song_id)

# LEVEL
signal level_finished(song_id, score)
signal level_started(song_id)
signal level_pickup_caught(pickup)
signal level_pickup_lost(pickup)
signal level_score_updated(score)
signal level_score_multiplier_updated(score_multiplier)
signal level_power_score_multiplier_updated(power_score_multiplier)
signal level_power_updated(power)
signal level_paused
signal level_resumed

signal level_start_request(song_id)
signal level_restart_request
signal level_pause_request
signal level_resume_request

# HOME
signal level_change_request(song_id)
