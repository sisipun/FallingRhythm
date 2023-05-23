class_name LevelInterface
extends Control


@export_node_path("StatsPanel") var _stats_panel_path: NodePath
@export_node_path("PauseButton") var _pause_button_path: NodePath
@export_node_path("PausePopup") var _pause_popup_path: NodePath
@export_node_path("CompletePopup") var _complete_popup_path: NodePath

@onready var _stats_panel: StatsPanel = get_node(_stats_panel_path)
@onready var _pause_button: PauseButton = get_node(_pause_button_path)
@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)
@onready var _complete_popup: CompletePopup = get_node(_complete_popup_path)


func _ready() -> void:
	EventStorage.level_finished.connect(_on_level_finished)
	EventStorage.level_started.connect(_on_level_started)
	EventStorage.level_score_updated.connect(_on_level_score_updated)
	EventStorage.level_score_multiplier_updated.connect(_on_level_score_multiplier_updated)
	EventStorage.level_power_score_multiplier_updated.connect(_on_level_power_score_multiplier_updated)
	EventStorage.level_power_updated.connect(_on_level_power_updated)
	EventStorage.level_paused.connect(_on_level_paused)
	EventStorage.level_resumed.connect(_on_level_resumed)


func _on_level_started(_song_id: String) -> void:
	_complete_popup.hide()
	
	_complete_popup.set_value(0, 0)
	
	_stats_panel.show()
	_pause_button.show()


func _on_level_finished(song_id: String, score: int) -> void:
	_stats_panel.hide()
	_pause_button.hide()
	
	_stats_panel.update_score(0)
	_stats_panel.update_score_multiplier(0)
	_stats_panel.update_power(0)
	
	_complete_popup.set_value(score, SongStorage.get_best_score(song_id))
	_complete_popup.show()


func _on_level_score_updated(score: int) -> void:
	_stats_panel.update_score(score)


func _on_level_score_multiplier_updated(score_multiplier: int) -> void:
	_stats_panel.update_score_multiplier(score_multiplier)


func _on_level_power_score_multiplier_updated(power_score_multiplier: int) -> void:
	_stats_panel.update_power_score_multiplier(power_score_multiplier)


func _on_level_power_updated(power: float) -> void:
	_stats_panel.update_power(power)

func _on_level_paused() -> void:
	_pause_button.hide()
	
	_pause_popup.show()


func _on_level_resumed() -> void:
	_pause_popup.hide()
	
	_pause_button.show()
