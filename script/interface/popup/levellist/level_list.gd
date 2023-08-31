class_name LevelList
extends VBoxContainer


@export var level_preview_scene: PackedScene

@export_node_path("Button") var _home_button_path: NodePath
@export_node_path("Button") var _play_button_path: NodePath

@onready var _home_button: Button = get_node(_home_button_path)
@onready var _play_button: Button = get_node(_play_button_path)

var selected_preview: LevelPreview = null 


func _ready() -> void:
	_home_button.pressed.connect(_on_home_button_pressed)
	_play_button.pressed.connect(_on_play_button_pressed)
	
	for song_timing in SongStorage.song_timings:
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		add_child(level_preview)
		level_preview.init(song_timing.id, SongStorage.get_best_score(song_timing.id))
		level_preview.pressed.connect(Callable(_on_level_pressed).bind(level_preview))


func _on_level_pressed(preview: LevelPreview) -> void:
	if selected_preview != null:
		selected_preview.unselect()
	selected_preview = preview
	selected_preview.select()


func _on_play_button_pressed() -> void:
	if selected_preview != null:
		selected_preview.unselect()
		EventStorage.emit_signal("level_start_request", selected_preview.song_id)
		selected_preview = null


func _on_home_button_pressed() -> void:
	if selected_preview != null:
		selected_preview.unselect()
		selected_preview = null
	
	EventStorage.emit_signal("home_return_request")
