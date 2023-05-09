class_name LoadingPopup
extends Control


@export_node_path("Timer") var _timer_path: NodePath

@onready var _timer: Timer = get_node(_timer_path)


func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	_timer.start()


func _on_timer_timeout() -> void:
	hide()
	EventStorage.emit_signal("level_start_request")
