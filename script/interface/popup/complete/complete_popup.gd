class_name CompletePopup
extends Control


@export_node_path("ValueLabel") var _score_label_path: NodePath
@export_node_path("ValueLabel") var _best_score_label_path: NodePath

@onready var _score_label: ValueLabel = get_node(_score_label_path)
@onready var _bests_score_label: ValueLabel = get_node(_best_score_label_path)


func set_value(score: int, best_score: int) -> void:
	_score_label.value = score
	_bests_score_label.value = best_score
