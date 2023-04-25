class_name Level
extends Node2D


@export_node_path("FingerArea") var left_finger_area_path: NodePath
@export_node_path("FingerArea") var right_finger_area_path: NodePath

@onready var left_finger: FingerArea = get_node(left_finger_area_path)
@onready var right_finger: FingerArea = get_node(right_finger_area_path)


func _ready() -> void:
	left_finger.pickup_caught.connect(_on_pickup_caught)
	left_finger.pickup_lost.connect(_on_pickup_lost)
	right_finger.pickup_caught.connect(_on_pickup_caught)
	right_finger.pickup_lost.connect(_on_pickup_lost)


func _on_pickup_caught(pickup: Pickup) -> void:
	print('caught')
	pickup.queue_free()


func _on_pickup_lost(pickup: Pickup) -> void:
	print('lost')
	pickup.queue_free()
