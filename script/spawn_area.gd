class_name SpawnArea
extends Area2D


@export_node_path("Timer") var _spawn_timer_path: NodePath
@export_node_path("CollisionShape2D") var _body_path: NodePath

@export var _pickup_scene: PackedScene

@onready var _spawn_timer: Timer = get_node(_spawn_timer_path)
@onready var _body: CollisionShape2D = get_node(_body_path) 


func _ready() -> void:
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var half_size: float = _body.shape.get_rect().size.x / 2.0
	var offset: float = randf_range(-half_size, half_size)
	
	var pickup: Pickup = _pickup_scene.instantiate()
	pickup.position.x += offset
	add_child(pickup)
