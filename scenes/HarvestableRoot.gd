extends Area2D
class_name HarvestableRoot

export var scroll_speed := 0.0

func _process(delta: float):
    position.x += delta * scroll_speed

    if position.x < -100:
        queue_free()