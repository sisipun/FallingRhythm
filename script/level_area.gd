class_name LevelArea
extends Node2D


const MAX_POWER_VALUE: float = 100.0

@export_node_path("FingerArea") var _left_finger_area_path: NodePath
@export_node_path("FingerArea") var _right_finger_area_path: NodePath
@export_node_path("AudioStreamPlayer") var _music_player_path: NodePath 
@export_node_path("Timer") var _power_timer_path: NodePath 

@export var _max_score_multiplier: int
@export_range(0, 100) var _pickups_percentage_to_increase_multiplier: float
@export_range(0, 100) var _power_increase_percentage_on_pickup: float
@export var _power_duration: int

@onready var _left_finger: FingerArea = get_node(_left_finger_area_path)
@onready var _right_finger: FingerArea = get_node(_right_finger_area_path)
@onready var _music_player: AudioStreamPlayer = get_node(_music_player_path)
@onready var _power_timer: Timer = get_node(_power_timer_path)
@onready var _power_decrease_on_timout_value: float = MAX_POWER_VALUE * _power_timer.wait_time / _power_duration
@onready var _power_increase_on_pickup_value: float = MAX_POWER_VALUE * _power_increase_percentage_on_pickup / 100.0

var _music_timing: MusicTiming
var _score: int:
	get:
		return _score
	set(new_score):
		_score = new_score
		EventStorage.emit_signal("level_score_updated", _score)
var _score_multiplier: int:
	get:
		return _score_multiplier
	set(new_score_multiplier):
		_score_multiplier = new_score_multiplier
		EventStorage.emit_signal("level_score_multiplier_updated", _score_multiplier)
var _power: float:
	get:
		return _power
	set(new_power):
		_power = clamp(new_power, 0, MAX_POWER_VALUE)
		EventStorage.emit_signal("level_power_updated", _power)
var _pickups_without_fail: int
var _pickups_count_to_increase_multiplier: int


func _ready() -> void:
	_on_window_size_changed()
	
	get_viewport().size_changed.connect(_on_window_size_changed)
	EventStorage.level_start_request.connect(_on_level_start_request)
	EventStorage.level_restart_request.connect(_on_level_restart_request)
	EventStorage.level_pause_request.connect(_on_level_pause_request)
	EventStorage.level_resume_request.connect(_on_level_resume_request)
	_left_finger.pickup_caught.connect(_on_pickup_caught)
	_left_finger.pickup_lost.connect(_on_pickup_lost)
	_right_finger.pickup_caught.connect(_on_pickup_caught)
	_right_finger.pickup_lost.connect(_on_pickup_lost)
	_music_player.finished.connect(_on_music_finished)
	_power_timer.timeout.connect(_on_power_timer_timeout)
	
	pause()


func _process(_delta: float) -> void:
	var playback_position: float = _music_player.get_playback_position()
	_left_finger.check_timing(playback_position)
	_right_finger.check_timing(playback_position)


func start(music_id: String) -> void:
	_music_timing = MusicStorage.get_music_timing(music_id)
	var left_finger_timings: Array[MusicTiming.Timing] = _music_timing.get_left_timings()
	var right_finger_timings: Array[MusicTiming.Timing] = _music_timing.get_right_timings()
	var timings_count: int = left_finger_timings.size() + right_finger_timings.size()
	
	_score = 0
	_score_multiplier = 1
	_pickups_without_fail = 0
	_pickups_count_to_increase_multiplier = int(timings_count * _pickups_percentage_to_increase_multiplier / 100.0)
	EventStorage.emit_signal("level_score_updated", _score)
	
	_music_player.stream = _music_timing.music
	_left_finger.init(left_finger_timings)
	_right_finger.init(right_finger_timings)
	
	_music_player.play()
	unpause()


func finish() -> void:
	pause()
	
	_power_timer.stop()
	_left_finger.clear_pickups()
	_right_finger.clear_pickups()


func pause() -> void:
	get_tree().paused = true


func unpause() -> void:
	get_tree().paused = false


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_level_start_request(music_id: String) -> void:
	start(music_id)
	EventStorage.emit_signal("level_started", music_id)


func _on_level_restart_request() -> void:
	start(_music_timing.id)
	EventStorage.emit_signal("level_started", _music_timing.id)


func _on_music_finished() -> void:
	finish()
	EventStorage.emit_signal("level_finished", _music_timing.id, _score)


func _on_level_pause_request() -> void:
	pause()
	EventStorage.emit_signal("level_paused")


func _on_level_resume_request() -> void:
	unpause()
	EventStorage.emit_signal("level_resumed")


func _on_pickup_caught(pickup: BasePickup) -> void:
	_pickups_without_fail += 1
	_score += pickup.score * _score_multiplier
	if _power_timer.is_stopped():
		_power += _power_increase_on_pickup_value
		if _power >= MAX_POWER_VALUE:
			_power_timer.start()
	
	if (
		_score_multiplier < _max_score_multiplier 
		and _pickups_without_fail > _pickups_count_to_increase_multiplier
	):
		_pickups_without_fail = 0
		_score_multiplier += 1


func _on_pickup_lost(_pickup: BasePickup) -> void:
	_pickups_without_fail = 0
	_score_multiplier = 1


func _on_power_timer_timeout() -> void:
	_power -= _power_decrease_on_timout_value
	if _power <= 0:
		_power_timer.stop()
