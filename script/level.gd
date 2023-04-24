class_name Level
extends Node2D


@export_node_path("PlayerArea") var _player_area_path: NodePath

@onready var _player_area: PlayerArea = get_node(_player_area_path)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		_player_area.move_player(event.relative.x)
