class_name Level
extends Node2D


@export_node_path("FingerArea") var left_finger_area_path: NodePath
@export_node_path("FingerArea") var right_finger_area_path: NodePath
@export_node_path("AudioStreamPlayer") var music_player_path: NodePath

@export var music_timing: MusicTiming

@onready var left_finger: FingerArea = get_node(left_finger_area_path)
@onready var right_finger: FingerArea = get_node(right_finger_area_path)
@onready var music_player: AudioStreamPlayer = get_node(music_player_path)


func _ready() -> void:
	music_player.stream = music_timing.music
	left_finger.init(music_timing.get_left_timings())
	right_finger.init(music_timing.get_right_timings())
	
	left_finger.pickup_caught.connect(_on_pickup_caught)
	left_finger.pickup_lost.connect(_on_pickup_lost)
	right_finger.pickup_caught.connect(_on_pickup_caught)
	right_finger.pickup_lost.connect(_on_pickup_lost)
	
	music_player.play()


func _process(_delta: float) -> void:
	left_finger.check_timing(music_player.get_playback_position())
	right_finger.check_timing(music_player.get_playback_position())


func _on_pickup_caught(pickup: Pickup) -> void:
	EventStorage.emit_signal("pickup_caught", pickup)
	pickup.queue_free()


func _on_pickup_lost(pickup: Pickup) -> void:
	EventStorage.emit_signal("pickup_lost", pickup)
	print('lost')
	pickup.queue_free()
