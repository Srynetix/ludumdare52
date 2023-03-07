extends Node2D
class_name GameScreen

const ROOT_ITEM_SCENE := preload("res://scenes/RootItem.tscn")
const DIRT_PARTICLES_SCENE := preload("res://scenes/DirtParticles.tscn")
const TRACK_1 := preload("res://assets/music/track1.ogg")

const HITS_PER_ROUND := 10
const SPEED_INCREASE := 10

onready var _player := $Layers/Player as Player
onready var _action_ui := $ActionUi as ActionUi
onready var _root_spawner := $RootSpawner as Spawner
onready var _sky_layer := $Layers/SkyLayer as ScrollLayer
onready var _background_layer := $Layers/BackgroundLayer as ScrollLayer
onready var _background_layer2 := $Layers/BackgroundLayer2 as ScrollLayer
onready var _below_layer := $Layers/Below as ScrollLayer
onready var _shade := $Layers/Shade as Shade

onready var _root_item_container := $Layers/Foreground/RootItems as Node2D
onready var _harvestable_root_container := $Layers/Foreground/HarvestableRoots as Node2D

onready var _score_value_label := $MarginContainer/ScoreContainer/ScoreValue as Label
onready var _fx_player := $FxPlayer as FxPlayer

var _current_random_word := ""
var _current_word_is_valid := false
var _current_root: HarvestableRoot = null
var _current_speed := -200.0
var _current_roots := Dictionary()
var _is_overlapping_root := false
var _current_score := 0
var _word_letter_count := 1
var _round_hits := 0
var _initial_speed := 0.0

var _background_tween: SceneTreeTween

func _ready() -> void:
    randomize()
    GameData.reset_game()

    _player.connect("root_sensor_entered", self, "_show_random_word")
    _player.connect("root_body_entered", self, "_set_root_overlapping", [true])
    _player.connect("root_body_missed", self, "_set_root_overlapping", [false])
    _root_spawner.connect("instance_spawned", self, "_spawn_root")

    _initial_speed = _current_speed
    _update_speed()

    _background_tween = get_tree().create_tween()
    _background_tween.set_loops()
    _background_tween.tween_property(_background_layer2.get_node("Background"), "position:y", 20.0, 2.0).as_relative().set_trans(Tween.TRANS_SINE)
    _background_tween.tween_property(_background_layer2.get_node("Background"), "position:y", -20.0, 2.0).as_relative().set_trans(Tween.TRANS_SINE)

    GameGlobalMusicPlayer.play_stream(TRACK_1)
    GameGlobalMusicPlayer.fade_in_on_voice(0)
    GameGlobalMusicPlayer.get_voice(0).pitch_scale = 1.0

    _player.walk()

    yield(get_tree().create_timer(1.0), "timeout")
    _root_spawner.spawn()

func _exit_tree():
    _background_tween.kill()

func _set_root_overlapping(_root: HarvestableRoot, status: bool) -> void:
    if status == true && _current_word_is_valid:
        _validate_kick()

    elif status == false:
        if !_current_word_is_valid:
            _game_over()
        else:
            _current_word_is_valid = false
            _reset_word()
            if _round_hits < HITS_PER_ROUND:
                _update_to_computed_speed()
            else:
                _start_new_round()

    _is_overlapping_root = status

func _start_new_round():
    _reset_speed()
    _word_letter_count += 1
    _round_hits = 0
    GameData.set_round(_word_letter_count)

    _shade.update_round_animate(_word_letter_count)

func _validate_kick() -> void:
    _stop_game()

    yield(_player.kick(), "completed")
    call_deferred("_spawn_random_root_item", _current_root.position)
    _fx_player.play_fx(FxPlayer.FxEnum.Kick)

    _current_root.queue_free()
    _reset_word()
    _round_hits += 1

    var timer = get_tree().create_timer(0.25)
    timer.connect("timeout", self, "_make_player_walk")

func _make_player_walk():
    _player.walk()

func _reset_word() -> void:
    _current_random_word = ""
    _current_root = null
    _action_ui.fade_out()

func _generate_random_letter() -> String:
    var letter_code := SxRand.range_i(65, 91)
    return char(letter_code)

func _generate_random_word(size: int) -> String:
    assert(size > 0)

    var word = ""
    for _n in range(size):
        word += _generate_random_letter()
    return word

func _show_random_word(root: HarvestableRoot) -> void:
    var word := _generate_random_word(_word_letter_count)
    _action_ui.show_word(word)
    _current_random_word = word
    _current_root = root

    _root_spawner.call_deferred("spawn")
    _fx_player.play_fx(FxPlayer.FxEnum.Appear)

func _game_over() -> void:
    _action_ui.show_failure()
    _current_random_word = ""
    _player.fall()
    _stop_game()
    _fx_player.play_fx(FxPlayer.FxEnum.Fall)

    var tween = get_tree().create_tween()
    var voice = GameGlobalMusicPlayer.get_voice(0)
    tween.tween_property(voice, "pitch_scale", 0.5, 0.75)
    tween.tween_callback(voice, "stop")

    yield(get_tree().create_timer(2), "timeout")
    get_tree().change_scene("res://screens/Results.tscn")

func _reset_speed() -> void:
    _current_speed = _initial_speed
    _update_speed()

func _update_to_computed_speed() -> void:
    _current_speed = _get_computed_speed()
    _update_speed()

func _stop_game() -> void:
    _current_speed = 0
    _update_speed()
    
func _update_speed() -> void:
    _sky_layer.scroll_speed = _current_speed / 256.0
    _background_layer.scroll_speed = _current_speed / 64.0
    _background_layer2.scroll_speed = _current_speed / 8.0
    _below_layer.scroll_speed = _current_speed
    for elem in _current_roots:
        var root = elem as HarvestableRoot
        root.scroll_speed = _current_speed

func _input(event):
    if event is InputEventKey:
        var key_event := event as InputEventKey
        if key_event.pressed:
            if _current_random_word != "":
                _validate_letter(key_event.scancode)

func _validate_letter(code: int) -> void:
    # Between A & Z
    if code >= 65 && code <= 90:
        var str_key = OS.get_scancode_string(code)
        if _current_random_word[0] == str_key:
            _on_valid_letter()
        else:
            _on_invalid_letter()

func _on_valid_letter() -> void:
    _current_random_word = _current_random_word.substr(1)
    if _current_random_word == "":
        _current_word_is_valid = true
        _action_ui.show_success()

        if _is_overlapping_root:
            _validate_kick()
    else:
        # Next letter !
        _action_ui.show_success()
    _fx_player.play_fx(FxPlayer.FxEnum.Success)

func _on_invalid_letter() -> void:
    _action_ui.show_failure()
    _current_random_word = ""
    _fx_player.play_fx(FxPlayer.FxEnum.Fail)

func _spawn_root(root: HarvestableRoot) -> void:
    root.position = _root_spawner.position
    root.scroll_speed = _current_speed
    root.connect("tree_exiting", self, "_remove_root", [root])
    _current_roots[root] = true
    _harvestable_root_container.add_child(root)

func _remove_root(root: HarvestableRoot) -> void:
    _current_roots.erase(root)

func _get_computed_speed() -> float:
    return _initial_speed - (_round_hits + 1) * SPEED_INCREASE

func _spawn_random_root_item(position: Vector2) -> void:
    var item := ROOT_ITEM_SCENE.instance() as RootItem
    item.randomize_item_type()

    # Scoring
    GameData.add_picked_item(item.item_type)
    _current_score += 100 * _word_letter_count
    GameData.set_score(_current_score)
    _update_score()

    item.position = position + Vector2(0, 16)
    item.rotation_degrees = rand_range(0, 360.0)
    _root_item_container.add_child(item)

    var fx := DIRT_PARTICLES_SCENE.instance() as CPUParticles2D
    fx.position = position + Vector2(0, 16)
    _root_item_container.add_child(fx)

func _update_score() -> void:
    _score_value_label.text = str(_current_score)
