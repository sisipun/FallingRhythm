class_name PauseButton
extends Button


func _ready():
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventStorage.emit_signal("level_pause_request")
