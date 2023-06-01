class_name Player
extends Area2D


@export_node_path("AnimationPlayer") var _animation_player_node: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)


func pickup_caught() -> void:
	if _animation_player.is_playing():
		_animation_player.stop()
	_animation_player.play("happy")


func pickup_lost() -> void:
	if _animation_player.is_playing():
		_animation_player.stop()
	_animation_player.play("sad")
