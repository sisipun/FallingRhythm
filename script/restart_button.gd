class_name RestartButton
extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventStorage.emit_signal("level_restart_request")
