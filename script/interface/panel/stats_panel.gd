class_name StatsPanel
extends Control


@export_node_path("ValueLabel") var _score_label_path: NodePath
@export_node_path("ValueLabel") var _score_multiplier_label_path: NodePath
@export_node_path("PowerBar") var _power_bar_path: NodePath

@onready var _score_label: ValueLabel = get_node(_score_label_path)
@onready var _score_multiplier_label: ValueLabel = get_node(_score_multiplier_label_path)
@onready var _power_bar: PowerBar = get_node(_power_bar_path)


func update_score(score: int) -> void:
	_score_label.value = score


func update_score_multiplier(score_multiplier: int) -> void:
	_score_multiplier_label.value = score_multiplier


func update_power(power: float) -> void:
	_power_bar.value = power
