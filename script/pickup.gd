class_name Pickup
extends Area2D


@export_node_path("CollisionShape2D") var _body_path: NodePath

@onready var _body: CollisionShape2D = get_node(_body_path)

var half_body_size: float
var velocity: float
var caught: bool


func init(_velocity: float, _position_x: float, _position_y: float = 0) -> void:
	self.half_body_size = _body.shape.radius * _body.global_scale.x
	self.velocity = _velocity
	self.position.x = _position_x
	self.position.y = _position_y
	self.caught = false


func _physics_process(delta: float) -> void:
	translate(Vector2(0, velocity) * delta)
