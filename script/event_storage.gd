extends Node


# LEVEL
signal level_finished
signal level_started
signal level_paused
signal level_resumed

signal level_start_request
signal level_pause_request
signal level_resume_request


# PICKUP
signal pickup_caught(pickup)
signal pickup_lost(pickup)
