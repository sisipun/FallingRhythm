class_name Level
extends Node2D


@export_node_path("FingerArea") var _left_finger_area_path: NodePath
@export_node_path("FingerArea") var _right_finger_area_path: NodePath
@export_node_path("AudioStreamPlayer") var _music_player_path: NodePath

@export var _music_timing: MusicTiming

@onready var _left_finger: FingerArea = get_node(_left_finger_area_path)
@onready var _right_finger: FingerArea = get_node(_right_finger_area_path)
@onready var _music_player: AudioStreamPlayer = get_node(_music_player_path)


func _ready() -> void:
	_music_player.stream = _music_timing.music
	_left_finger.init(_music_timing.get_left_timings())
	_right_finger.init(_music_timing.get_right_timings())
	
	_on_window_size_changed()
	
	get_viewport().size_changed.connect(_on_window_size_changed)
	EventStorage.level_pause_request.connect(_on_level_pause_request)
	EventStorage.level_resume_request.connect(_on_level_resume_request)
	
	_left_finger.pickup_caught.connect(_on_pickup_caught)
	_left_finger.pickup_lost.connect(_on_pickup_lost)
	_right_finger.pickup_caught.connect(_on_pickup_caught)
	_right_finger.pickup_lost.connect(_on_pickup_lost)
	
	_music_player.finished.connect(_on_music_finished)
	
	_music_player.play()


func _process(_delta: float) -> void:
	_left_finger.check_timing(_music_player.get_playback_position())
	_right_finger.check_timing(_music_player.get_playback_position())


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_level_pause_request() -> void:
	get_tree().paused = true


func _on_level_resume_request() -> void:
	get_tree().paused = false


func _on_pickup_caught(pickup: Pickup) -> void:
	EventStorage.emit_signal("pickup_caught", pickup)
	pickup.queue_free()


func _on_pickup_lost(pickup: Pickup) -> void:
	print('lost')
	EventStorage.emit_signal("pickup_lost", pickup)
	pickup.queue_free()


func _on_music_finished() -> void:
	print('finished')
	EventStorage.emit_signal("level_finished")
