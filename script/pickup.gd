class_name Pickup
extends Area2D


var velocity: float
var caught: bool


func init(_velocity: float, _position: float) -> void:
	self.velocity = _velocity
	self.position.x = _position
	self.caught = false


func _physics_process(delta: float) -> void:
	translate(Vector2(0, velocity) * delta)
