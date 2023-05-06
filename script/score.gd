class_name ScoreLabel
extends Label

var value: int:
	get:
		return value
	set(_value):
		value = _value
		text = str(value)


func _ready() -> void:
	self.value = 0
	EventStorage.pickup_caught.connect(_on_pickup_caught)


func _on_pickup_caught(_pickup: Pickup) -> void:
	value += 1
