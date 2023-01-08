extends Node2D
class_name ScrollLayer

export var scroll_speed := 0.0 setget _set_scroll_speed

func _ready():
    _update_children()

func _update_children():
    for child in get_children():
        if child is RepeatingSprite:
            var sprite = child as RepeatingSprite
            sprite.scroll_speed = scroll_speed

        elif child is ScreenLoopingSprite:
            var sprite = child as ScreenLoopingSprite
            sprite.move_speed = scroll_speed

func _set_scroll_speed(value: float) -> void:
    scroll_speed = value
    _update_children()