class_name PlayerArea
extends Area2D


@export_node_path("Player") var _player_path: NodePath
@export_node_path("CollisionShape2D") var _body_path: NodePath

@onready var _player: Player = get_node(_player_path)
@onready var _body: CollisionShape2D = get_node(_body_path) 


func move_player(relative_movement: float) -> void:
	var half_size: float = _body.shape.get_rect().size.x / 2.0
	var new_position: float = _player.position.x + relative_movement
	var body_right_border: float = _body.position.x + half_size
	var body_left_border: float = _body.position.x - half_size
	if new_position > body_right_border: 
		_player.position.x = body_right_border
	elif new_position < body_left_border:
		_player.position.x = body_left_border
	else:
		_player.position.x = new_position
