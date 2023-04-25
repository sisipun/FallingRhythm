class_name Player
extends Area2D


signal pickup_caught(pickup)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Pickup and not area.caught:
		area.caught = true
		emit_signal("pickup_caught", area)
