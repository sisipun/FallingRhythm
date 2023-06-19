class_name LevelListButton
extends TextureButton


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventStorage.emit_signal("home_level_list_show_request")
