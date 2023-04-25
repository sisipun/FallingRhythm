class_name Pickup
extends Area2D


@export_range(0, 10000) var velocity: float

var caught: bool = false


func _physics_process(delta: float) -> void:
	translate(Vector2(0, velocity) * delta)
