extends Area2D
class_name RootItem

const ANGULAR_SPEED := 10
const SPEED := 500

onready var _sprite := $Sprite as Sprite
var _velocity := Vector2.ZERO

export(RootItemType.RootItemTypeEnum) var item_type: int = RootItemType.RootItemTypeEnum.Potato

func _ready() -> void:
    _update_item_texture()

func _process(delta):
    var game_size = get_viewport_rect().size

    _velocity = Vector2.RIGHT.rotated(-PI / 4) * SPEED
    position += _velocity * delta
    rotation += ANGULAR_SPEED * delta
    
    var scale_factor = clamp(scale.x - 0.65 * delta, 0, 1)
    scale = Vector2(scale_factor, scale_factor)

    if position.x + 100 > game_size.x:
        queue_free()

func randomize_item_type() -> void:
    item_type = RootItemType.random_item_type()

func _update_item_texture() -> void:
    _sprite.texture = RootItemType.get_texture(item_type)
