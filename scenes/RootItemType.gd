extends Reference
class_name RootItemType

const _potato_texture := preload("res://assets/textures/potato.png")
const _carrot_texture := preload("res://assets/textures/carrot.png")
const _tomato_texture := preload("res://assets/textures/tomato.png")
const _cucumber_texture := preload("res://assets/textures/cucumber.png")
const _eggplant_texture := preload("res://assets/textures/eggplant.png")
const _lemon_texture := preload("res://assets/textures/lemon.png")

const _rock_texture := preload("res://assets/textures/rock.png")
const _can_texture := preload("res://assets/textures/can.png")
const _coke_texture := preload("res://assets/textures/coke.png")
const _boot_texture := preload("res://assets/textures/boot.png")
const _sheep_texture := preload("res://assets/textures/sheep.png")

enum RootItemTypeEnum {
    Potato = 0,
    Carrot,
    Tomato,
    Cucumber,
    Eggplant,
    Lemon,

    Rock,
    Can,
    Coke,
    Boot,
    Sheep,

    MAX
}

const ITEM_TYPE_COUNT := RootItemTypeEnum.MAX
const ITEM_TYPE_MISC_START := RootItemTypeEnum.Rock
const ITEM_TYPE_MISC_CHANCE := 8    # 1 / x

static func random_item_type() -> int:
    var misc_object = SxRand.range_i(0, ITEM_TYPE_MISC_CHANCE)
    if misc_object == 0:
        return SxRand.range_i(ITEM_TYPE_MISC_START, ITEM_TYPE_COUNT)
    return SxRand.range_i(0, ITEM_TYPE_MISC_START)

static func get_texture(item_type: int) -> Texture:
    match item_type:
        RootItemTypeEnum.Potato:
            return _potato_texture
        RootItemTypeEnum.Carrot:
            return _carrot_texture
        RootItemTypeEnum.Tomato:
            return _tomato_texture
        RootItemTypeEnum.Cucumber:
            return _cucumber_texture
        RootItemTypeEnum.Eggplant:
            return _eggplant_texture
        RootItemTypeEnum.Lemon:
            return _lemon_texture

        RootItemTypeEnum.Rock:
            return _rock_texture
        RootItemTypeEnum.Can:
            return _can_texture
        RootItemTypeEnum.Coke:
            return _coke_texture
        RootItemTypeEnum.Boot:
            return _boot_texture
        RootItemTypeEnum.Sheep:
            return _sheep_texture

    return null
