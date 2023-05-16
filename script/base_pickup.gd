class_name BasePickup
extends Area2D


signal caught
signal lost


@export_node_path("CollisionShape2D") var _body_path: NodePath

@onready var _body: CollisionShape2D = get_node(_body_path)

var velocity: float
var score: int
var body_size: float
var half_body_size: float
var has_caught: bool


func base_init(_velocity: float, _position: Vector2, _score: int) -> void:
	self.velocity = _velocity
	self.position = _position
	self.score = _score
	self.body_size = _body.shape.get_rect().size.x * _body.global_scale.x
	self.half_body_size = body_size / 2.0
	self.has_caught = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _physics_process(delta: float) -> void:
	translate(Vector2(0, velocity) * delta)


func _on_area_entered(_area: Area2D) -> void:
	pass


func _on_area_exited(_area: Area2D) -> void:
	pass
