extends Node2D

func _ready() -> void:
    yield(get_tree().create_timer(1.0), "timeout")

    var image = get_viewport().get_texture().get_data()
    image.flip_y()
    image.save_png("res://promo/screenshot.png")