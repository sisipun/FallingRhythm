class_name Interface
extends Control


@export_node_path("PausePopup") var _pause_popup_path: NodePath

@onready var _pause_popup: PausePopup = get_node(_pause_popup_path)


func _ready() -> void:
	EventStorage.level_pause_request.connect(_on_level_pause_request)
	EventStorage.level_resume_request.connect(_on_level_resume_request)


func _on_level_pause_request() -> void:
	_pause_popup.show()


func _on_level_resume_request() -> void:
	_pause_popup.hide()
