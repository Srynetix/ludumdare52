extends Sprite
class_name ScreenLoopingSprite

export var move_speed := 0.0

var _texture_size: Vector2 = Vector2.ZERO

func _ready():
    _texture_size = texture.get_size()

func _process(delta: float):
    var game_size := get_viewport_rect().size

    if _texture_size != Vector2.ZERO:
        position.x = wrapf(position.x + delta * move_speed, -_texture_size.x / 2, game_size.x + _texture_size.x / 2)