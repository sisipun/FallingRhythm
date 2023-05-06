class_name Interface
extends Control


@export_node_path("PauseButton") var _pause_button_path: NodePath
@export_node_path("PausePopup") var _pause_popup_path: NodePath

@onready var _pause_button: PauseButton = get_node(_pause_button_path)
@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)


func _ready() -> void:
	EventStorage.level_pause_request.connect(_on_level_pause_request)
	EventStorage.level_resume_request.connect(_on_level_resume_request)


func _on_level_pause_request() -> void:
	_pause_button.hide()
	_pause_popup.show()


func _on_level_resume_request() -> void:
	_pause_popup.hide()
	_pause_button.show()
