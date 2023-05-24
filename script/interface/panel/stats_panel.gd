class_name StatsPanel
extends Control


@export_node_path("ValueLabel") var _score_label_path: NodePath
@export_node_path("ValueLabel") var _score_multiplier_label_path: NodePath
@export_node_path("PowerBar") var _power_bar_path: NodePath

@onready var _score_label: ValueLabel = get_node(_score_label_path)
@onready var _score_multiplier_label: ValueLabel = get_node(_score_multiplier_label_path)
@onready var _power_bar: PowerBar = get_node(_power_bar_path)


var score_multiplier: int = 1
var power_score_multiplier: int = 1


func update_score(score: int) -> void:
	_score_label.value = score


func update_score_multiplier(_score_multiplier: int) -> void:
	self.score_multiplier = _score_multiplier
	_score_multiplier_label.value = score_multiplier * power_score_multiplier


func update_power(power: float, max_power: float) -> void:
	_power_bar.value = power
	_power_bar.max_value = max_power


func start_power(_power_score_multiplier: int) -> void:
	self.power_score_multiplier = _power_score_multiplier
	_score_multiplier_label.value = score_multiplier * power_score_multiplier


func end_power() -> void:
	self.power_score_multiplier = 1
	_score_multiplier_label.value = score_multiplier
