class_name BasePickup
extends Area2D


signal caught
signal lost


@export_node_path("CollisionShape2D") var _body_path: NodePath

@onready var _body: CollisionShape2D = get_node(_body_path)

var spawn_second: float
var catch_second: float
var duration: float
var velocity: float
var spawn_position: Vector2
var catch_position: Vector2
var score: int
var body_size: float
var half_body_size: float
var has_caught: bool

var _spawn_to_catch_inverse_period: float


func base_init(
	_spawn_second: float, 
	_catch_second: float, 
	_duration: float, 
	_velocity: float, 
	_spawn_position: Vector2,
	_catch_position: Vector2,
	_score: int
) -> void:
	self.spawn_second = _spawn_second
	self.catch_second = _catch_second
	self.duration = _duration
	self.velocity = _velocity
	self.position = _spawn_position
	self.spawn_position = _spawn_position
	self.catch_position = _catch_position
	self.score = _score
	self.body_size = _body.shape.get_rect().size.x * _body.global_scale.x
	self.half_body_size = body_size / 2.0
	self.has_caught = false
	
	self._spawn_to_catch_inverse_period = 1 / (_catch_second - _spawn_second)


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func sound_process(current_second: float) -> void:
	self.position = lerp(
		spawn_position,
		catch_position,
		(current_second - spawn_second) * _spawn_to_catch_inverse_period
	)


func _process(_delta: float) -> void:
	pass
	# More smooth way to moving pickups. Maybe return it later after testing move approach
	# translate(Vector2(0, velocity) * delta)


func _on_area_entered(_area: Area2D) -> void:
	pass


func _on_area_exited(_area: Area2D) -> void:
	pass
