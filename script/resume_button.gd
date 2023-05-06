class_name ResumeButton
extends Button


func _ready():
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventStorage.emit_signal("level_resume_request")
