class_name Interface
extends Control


@export_node_path("ValueLabel") var _score_label_path: NodePath
@export_node_path("PauseButton") var _pause_button_path: NodePath
@export_node_path("PausePopup") var _pause_popup_path: NodePath
@export_node_path("CompletePopup") var _complete_popup_path: NodePath

@onready var _score_label: ValueLabel = get_node(_score_label_path)
@onready var _pause_button: PauseButton = get_node(_pause_button_path)
@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)
@onready var _complete_popup: CompletePopup = get_node(_complete_popup_path)


func _ready() -> void:
	EventStorage.level_finished.connect(_on_level_finished)
	EventStorage.level_started.connect(_on_level_started)
	EventStorage.level_paused.connect(_on_level_paused)
	EventStorage.level_resumed.connect(_on_level_resumed)
	EventStorage.pickup_caught.connect(_on_pickup_caught)


func _on_level_started() -> void:
	_complete_popup.hide()
	
	_score_label.show()
	_pause_button.show()


func _on_level_finished() -> void:
	_score_label.hide()
	_pause_button.hide()
	
	_complete_popup.set_value(_score_label.value, 0)
	_complete_popup.show()
	
	_score_label.value = 0


func _on_level_paused() -> void:
	_pause_button.hide()
	
	_pause_popup.show()


func _on_level_resumed() -> void:
	_pause_popup.hide()
	
	_pause_button.show()


func _on_pickup_caught(_pickup: Pickup) -> void:
	_score_label.value += 1
