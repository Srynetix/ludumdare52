extends Sprite
class_name RepeatingSprite

export var scroll_speed := 0.0

var _texture_size: Vector2 = Vector2.ZERO

func _ready():
    _texture_size = texture.get_size()
    if _texture_size != Vector2.ZERO:
        region_rect.position = Vector2.ZERO
        region_rect.size = _texture_size
        region_enabled = true

func _process(delta: float):
    if _texture_size != Vector2.ZERO:
        region_rect.position.x = wrapf(region_rect.position.x + delta * -scroll_speed, 0, region_rect.size.x * 2)