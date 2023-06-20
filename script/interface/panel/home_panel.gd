class_name HomePanel
extends Control


@export_node_path("Label") var _song_name_label_path: NodePath
@export_node_path("ValueLabel") var _song_best_score_label_path: NodePath

@export_node_path("LevelListButton") var _level_list_button_path: NodePath
@export_node_path("LevelListPopup") var _level_list_popup_path: NodePath

@onready var _song_name_label: Label = get_node(_song_name_label_path)
@onready var _song_best_score_label: ValueLabel = get_node(_song_best_score_label_path)

@onready var _level_list_button: LevelListButton = get_node(_level_list_button_path)
@onready var _level_list_popup: LevelListPopup = get_node(_level_list_popup_path)


func _ready() -> void:
	EventStorage.home_returned.connect(_on_home_returned)
	EventStorage.home_level_list_shown.connect(_on_home_level_list_shown)
	
	_update_song()


func _on_home_returned() -> void:
	_level_list_popup.hide()
	
	_update_song()
	
	_level_list_button.show()


func _on_home_level_list_shown() -> void:
	_level_list_button.hide()
	
	_level_list_popup.show()


func _update_song() -> void:
	var current_song_id: String = SongStorage.get_current_song_id()
	_song_name_label.text = current_song_id
	_song_best_score_label.value = SongStorage.get_best_score(current_song_id)
