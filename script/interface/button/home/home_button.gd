class_name HomeButton
extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventStorage.emit_signal("scene_switch_home")
