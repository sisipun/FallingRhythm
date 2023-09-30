class_name Player
extends Area2D


@export_node_path("AnimationPlayer") var _animation_player_node: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)
@onready var _initial_position: Vector2 = Vector2(self.position.x, self.position.y)


func reset_position() -> void:
	self.position.x = _initial_position.x
	self.position.y = _initial_position.y


func pickup_caught() -> void:
	if _animation_player.is_playing():
		_animation_player.stop()
	_animation_player.play("happy")


func pickup_lost() -> void:
	if _animation_player.is_playing():
		_animation_player.stop()
	_animation_player.play("sad")
