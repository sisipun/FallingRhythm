class_name SceneSwitcher
extends Node


@export_node_path("Node") var _initial_scene_path: NodePath
@export var _home_scene: PackedScene
@export var _level_scene: PackedScene

var _current_scene: Node


func _ready() -> void:
	_current_scene = get_node(_initial_scene_path)
	
	EventStorage.scene_switch_home.connect(_on_scene_switch_home)
	EventStorage.scene_switch_level.connect(_on_scene_switch_level)


func _on_scene_switch_home() -> void:
	_change_scene(_home_scene)


func _on_scene_switch_level(music_id: String) -> void:
	_change_scene(_level_scene)
	EventStorage.emit_signal("level_start_request", music_id)


func _change_scene(scene: PackedScene) -> void:
	get_tree().paused = false
	var new_scene: Node = scene.instantiate()
	add_child(new_scene)
	_current_scene.queue_free()
	_current_scene = new_scene
