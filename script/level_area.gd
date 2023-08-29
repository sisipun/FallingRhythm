class_name LevelArea
extends Node2D

enum State {
	HOME,
	STARTED,
	PAUSED,
	RESUMED,
	COMPLETED
}

@export_node_path("FingerArea") var _left_finger_area_path: NodePath
@export_node_path("FingerArea") var _right_finger_area_path: NodePath
@export_node_path("Countdown") var _resume_countdown_path: NodePath
@export_node_path("ValueTween") var _resume_tween_path: NodePath
@export_node_path("AudioStreamPlayer") var _song_player_path: NodePath

@export var _max_score_multiplier: int
@export var _power_score_multiplier: int
@export var _max_power_value: int
@export_range(0, 100) var _pickups_percentage_to_increase_multiplier: float
@export_range(0, 100) var _pickups_percentage_to_increase_full_power: float
@export var _power_duration: int

@onready var _left_finger: FingerArea = get_node(_left_finger_area_path)
@onready var _right_finger: FingerArea = get_node(_right_finger_area_path)
@onready var _resume_countdown: Countdown = get_node(_resume_countdown_path)
@onready var _resume_tween: ValueTween = get_node(_resume_tween_path)
@onready var _song_player: AudioStreamPlayer = get_node(_song_player_path)

var _song_timing: SongTiming
var _score: int:
	get:
		return _score
	set(new_score):
		if _score != new_score:
			_score = new_score
			EventStorage.emit_signal("level_score_updated", _score)
var _score_multiplier: int:
	get:
		return _score_multiplier
	set(new_score_multiplier):
		if _score_multiplier != new_score_multiplier:
			_score_multiplier = new_score_multiplier
			EventStorage.emit_signal("level_score_multiplier_updated", _score_multiplier)
var _power: float:
	get:
		return _power
	set(new_power):
		if _power != new_power:
			_power = clamp(new_power, 0, _max_power_value)
			EventStorage.emit_signal("level_power_updated", _power, _max_power_value)
var _pickups_without_fail: int
var _pickups_count_to_increase_multiplier: int
var _power_increase_on_pickup_value: float
var _power_on: bool = false
var _state: State
var haptic = null


func _ready() -> void:
	_on_window_size_changed()
	
	get_viewport().size_changed.connect(_on_window_size_changed)
	EventStorage.home_return_request.connect(_on_home_return_request)
	EventStorage.home_level_list_show_request.connect(_on_home_level_list_show_request)
	EventStorage.level_start_request.connect(_on_level_start_request)
	EventStorage.level_restart_request.connect(_on_level_restart_request)
	EventStorage.level_pause_request.connect(_on_level_pause_request)
	EventStorage.level_resume_request.connect(_on_level_resume_request)
	EventStorage.level_start_power_request.connect(_on_level_start_power_request)
	_left_finger.pickup_caught.connect(_on_pickup_caught)
	_left_finger.pickup_lost.connect(_on_pickup_lost)
	_left_finger.player_moved.connect(_on_player_moved)
	_right_finger.pickup_caught.connect(_on_pickup_caught)
	_right_finger.pickup_lost.connect(_on_pickup_lost)
	_right_finger.player_moved.connect(_on_player_moved)
	_resume_countdown.updated.connect(_on_resume_countdown_updated)
	_resume_countdown.finished.connect(_on_resume_countdown_finished)
	_resume_tween.updated.connect(_on_resume_tween_updated)
	_song_player.finished.connect(_on_song_finished)
	
	_state = State.HOME
	
	if Engine.has_singleton("Haptic"):
		haptic = Engine.get_singleton("Haptic")


func _process(_delta: float) -> void:
	sound_process(get_playback_position())


func sound_process(current_second: float) -> void:
	_left_finger.sound_process(current_second)
	_right_finger.sound_process(current_second)


func start(song_id: String) -> void:
	_song_timing = SongStorage.get_song_timing(song_id)
	var left_finger_timings: Array[SongTiming.Timing] = _song_timing.get_left_timings()
	var right_finger_timings: Array[SongTiming.Timing] = _song_timing.get_right_timings()
	var timings_count: int = left_finger_timings.size() + right_finger_timings.size()
	
	_score = 0
	_score_multiplier = 1
	_power = 0.0
	_pickups_without_fail = 0
	
	var _pickups_share_to_increase_multiplier: float = _pickups_percentage_to_increase_multiplier / 100.0
	var _pickups_share_to_increase_full_power: float = _pickups_percentage_to_increase_full_power / 100.0
	_pickups_count_to_increase_multiplier = int(timings_count * _pickups_share_to_increase_multiplier)
	var _pickups_count_to_increase_full_power: int = int(timings_count * _pickups_share_to_increase_full_power)
	_power_increase_on_pickup_value = float(_max_power_value) / _pickups_count_to_increase_full_power
	
	EventStorage.emit_signal("level_score_updated", _score)
	
	_song_player.stream = _song_timing.song
	_left_finger.init(left_finger_timings)
	_right_finger.init(right_finger_timings)
	
	get_tree().paused = false
	_song_player.play()
	_state = State.STARTED
	
	EventStorage.emit_signal("level_started", song_id)


func pause() -> void:
	get_tree().paused = true
	_state = State.PAUSED
	EventStorage.emit_signal("level_paused")


func home() -> void:
	get_tree().paused = false
	_song_player.stop()
	
	_left_finger.reset_area()
	_right_finger.reset_area()
	
	_state = State.HOME
	EventStorage.emit_signal("home_returned")


func resume_start() -> void:
	_resume_countdown.start()
	_resume_tween.start(_song_player.get_playback_position())
	
	_state = State.RESUMED


func resume_complete() -> void:
	get_tree().paused = false
	_song_player.play(_resume_tween.value)
	
	_state = State.STARTED
	EventStorage.emit_signal("level_resumed")


func complete() -> void:
	_song_player.stop()
	
	_left_finger.reset_area()
	_right_finger.reset_area()
	
	_state = State.COMPLETED
	EventStorage.emit_signal("level_completed", _song_timing.id, _score)


func get_playback_position() -> float:
	return (
		_song_player.get_playback_position() 
		+ AudioServer.get_time_since_last_mix() 
		- AudioServer.get_output_latency()
	)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_home_return_request() -> void:
	home()


func _on_home_level_list_show_request() -> void:
	get_tree().paused = true
	
	EventStorage.emit_signal("home_level_list_shown")


func _on_level_start_request(song_id: String) -> void:
	start(song_id)


func _on_level_restart_request() -> void:
	start(_song_timing.id)


func _on_level_pause_request() -> void:
	pause()


func _on_level_resume_request() -> void:
	resume_start()


func _on_resume_countdown_finished() -> void:
	resume_complete()


func _on_song_finished() -> void:
	complete()


func _on_level_start_power_request() -> void:
	if _power < _max_power_value:
		return
	
	var _tween: Tween = create_tween()
	_power_on = true
	EventStorage.emit_signal("level_power_started", _power_score_multiplier)
	_tween.tween_property(self, "_power", 0.0, _power_duration)
	await _tween.finished
	_power_on = false
	EventStorage.emit_signal("level_power_ended")


func _on_pickup_caught(pickup: BasePickup) -> void:
	print('(', pickup.catch_second, ',', _song_player.get_playback_position(), ')=', pickup.catch_second - _song_player.get_playback_position())
	if haptic != null:
		haptic.impact(1)
	
	_pickups_without_fail += 1
	if not _power_on:
		_score += pickup.score * _score_multiplier
		_power += _power_increase_on_pickup_value
	else:
		_score += pickup.score * _score_multiplier * _power_score_multiplier
	
	if (
		_score_multiplier < _max_score_multiplier 
		and _pickups_without_fail > _pickups_count_to_increase_multiplier
	):
		_pickups_without_fail = 0
		_score_multiplier += 1


func _on_pickup_lost(_pickup: BasePickup) -> void:
	_pickups_without_fail = 0
	_score_multiplier = 1


func _on_player_moved(_relative_x: float) -> void:
	if _state == State.HOME:
		start(SongStorage.get_current_song_id())


func _on_resume_tween_updated(value: float) -> void:
	if (value >= 0):
		sound_process(value)


func _on_resume_countdown_updated(value: int) -> void:
	EventStorage.emit_signal("level_resume_countdown_updated", value)
