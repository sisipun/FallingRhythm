class_name LevelInterface
extends Control


@export_node_path("HomePanel") var _home_panel_path: NodePath

@export_node_path("StatsPanel") var _stats_panel_path: NodePath
@export_node_path("PowerButton") var _power_button_path: NodePath

@export_node_path("PauseButton") var _pause_button_path: NodePath
@export_node_path("PausePopup") var _pause_popup_path: NodePath
@export_node_path("Label") var _resume_countdown_path: NodePath

@export_node_path("CompletePopup") var _complete_popup_path: NodePath

@onready var _home_panel: HomePanel = get_node(_home_panel_path)

@onready var _stats_panel: StatsPanel = get_node(_stats_panel_path)
@onready var _power_button: PowerButton = get_node(_power_button_path)

@onready var _pause_button: PauseButton = get_node(_pause_button_path)
@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)
@onready var _resume_countdown: Label = get_node(_resume_countdown_path)

@onready var _complete_popup: CompletePopup = get_node(_complete_popup_path)


func _ready() -> void:
	EventStorage.home_returned.connect(_on_home_returned)
	EventStorage.level_started.connect(_on_level_started)
	EventStorage.level_completed.connect(_on_level_completed)
	EventStorage.level_score_updated.connect(_on_level_score_updated)
	EventStorage.level_score_multiplier_updated.connect(_on_level_score_multiplier_updated)
	EventStorage.level_power_updated.connect(_on_level_power_updated)
	EventStorage.level_power_started.connect(_on_level_power_started)
	EventStorage.level_power_ended.connect(_on_level_power_ended)
	EventStorage.level_paused.connect(_on_level_paused)
	EventStorage.level_resume_request.connect(_on_level_resume_request)
	EventStorage.level_resume_countdown_updated.connect(_on_level_resume_countdown_updated)
	EventStorage.level_resumed.connect(_on_level_resumed)


func _on_home_returned() -> void:
	_stats_panel.hide()
	_power_button.hide()
	_pause_button.hide()
	_pause_popup.hide()
	_complete_popup.hide()
	
	_home_panel.show()


func _on_level_started(_song_id: String) -> void:
	_complete_popup.hide()
	_home_panel.hide()
	
	_stats_panel.show()
	_pause_button.show()


func _on_level_completed(song_id: String, score: int) -> void:
	_stats_panel.hide()
	_pause_button.hide()
	_power_button.hide()
	
	_complete_popup.set_value(score, SongStorage.get_best_score(song_id))
	_complete_popup.show()


func _on_level_score_updated(score: int) -> void:
	_stats_panel.update_score(score)


func _on_level_score_multiplier_updated(score_multiplier: int) -> void:
	_stats_panel.update_score_multiplier(score_multiplier)


func _on_level_power_updated(power: float, max_power: float) -> void:
	_stats_panel.update_power(power, max_power)
	if power == max_power:
		_power_button.show()


func _on_level_power_started(power_score_multiplier: int) -> void:
	_stats_panel.start_power(power_score_multiplier)
	_power_button.hide()


func _on_level_power_ended() -> void:
	_stats_panel.end_power()


func _on_level_paused() -> void:
	_pause_popup.show()


func _on_level_resume_request() -> void:
	_pause_popup.hide()
	_resume_countdown.show()


func _on_level_resume_countdown_updated(countdown: int) -> void:
	_resume_countdown.text = str(countdown)


func _on_level_resumed() -> void:
	_resume_countdown.hide()
	_pause_popup.hide()
