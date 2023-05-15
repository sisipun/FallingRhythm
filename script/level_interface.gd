class_name LevelInterface
extends Control


@export_node_path("ValueLabel") var _score_label_path: NodePath
@export_node_path("ValueLabel") var _score_multiplier_label_path: NodePath
@export_node_path("PauseButton") var _pause_button_path: NodePath
@export_node_path("PausePopup") var _pause_popup_path: NodePath
@export_node_path("CompletePopup") var _complete_popup_path: NodePath

@onready var _score_label: ValueLabel = get_node(_score_label_path)
@onready var _score_multiplier_label: ValueLabel = get_node(_score_multiplier_label_path)
@onready var _pause_button: PauseButton = get_node(_pause_button_path)
@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)
@onready var _complete_popup: CompletePopup = get_node(_complete_popup_path)


func _ready() -> void:
	EventStorage.level_finished.connect(_on_level_finished)
	EventStorage.level_started.connect(_on_level_started)
	EventStorage.level_score_updated.connect(_on_level_score_updated)
	EventStorage.level_score_multiplier_updated.connect(_on_level_score_multiplier_updated)
	EventStorage.level_paused.connect(_on_level_paused)
	EventStorage.level_resumed.connect(_on_level_resumed)


func _on_level_started(_music_id: String) -> void:
	_complete_popup.hide()
	
	_score_label.show()
	_score_multiplier_label.show()
	_pause_button.show()


func _on_level_finished(music_id: String, score: int) -> void:
	_score_label.hide()
	_score_multiplier_label.hide()
	_pause_button.hide()
	
	_complete_popup.set_value(score, MusicStorage.get_best_score(music_id))
	_complete_popup.show()


func _on_level_score_updated(score: int) -> void:
	_score_label.value = score


func _on_level_score_multiplier_updated(score_multiplier: int) -> void:
	_score_multiplier_label.value = score_multiplier


func _on_level_paused() -> void:
	_pause_button.hide()
	
	_pause_popup.show()


func _on_level_resumed() -> void:
	_pause_popup.hide()
	
	_pause_button.show()
