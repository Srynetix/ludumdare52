extends SxGameData

const INITIAL_HIGH_SCORE := 21000   # 6 complete rounds

var _picked_items: Array = []
var _last_score: int = 0
var _last_round: int = 0
var _highscore: int = 0
var _highscore_owner: String = ""

func _ready() -> void:
    default_file_path = "user://ld52-save.dat"

    load_from_disk()
    reset_game()

func is_intro_already_seen() -> bool:
    return load_value("intro_already_seen", false)

func set_intro_already_seen(value: bool) -> void:
    store_value("intro_already_seen", value)
    persist_to_disk()

func get_highscore() -> int:
    return _highscore

func get_highscore_owner() -> String:
    return _highscore_owner

func set_highscore(score: int) -> void:
    _highscore = score
    _highscore_owner = "YOU"

    store_value("highscore", _highscore)
    store_value("highscore_owner", _highscore_owner)
    persist_to_disk()

func reset_game() -> void:
    _picked_items = []
    _last_score = 0
    _last_round = 0
    _highscore = load_value("highscore", INITIAL_HIGH_SCORE)
    _highscore_owner = load_value("highscore_owner", "AAA")

func add_picked_item(item_type: int) -> void:
    _picked_items.append(item_type)

func get_picked_items() -> Array:
    return _picked_items

func set_score(score: int) -> void:
    _last_score = score

func get_score() -> int:
    return _last_score

func set_round(round_: int) -> void:
    _last_round = round_

func get_round() -> int:
    return _last_round