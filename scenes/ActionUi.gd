extends Node2D
class_name ActionUi

onready var _label := $RichTextLabel as RichTextLabel

var _word := ""
var _validated_count := 0
var _failed := false
var _tween: SceneTreeTween

func _ready() -> void:
    modulate = Color.transparent

    var game_size = get_viewport_rect().size
    position = game_size / 2

    _label.rect_position.y -= 20

    # Yay!
    _tween = get_tree().create_tween()
    _tween.set_ease(Tween.EASE_IN_OUT)
    # _tween.tween_property(_label, "rect_rotation", 10.0, 1.0).set_trans(Tween.TRANS_SINE)
    _tween.parallel().tween_property(_label, "rect_position:y", 40.0, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
    # _tween.tween_property(_label, "rect_rotation", -10.0, 1.0).set_trans(Tween.TRANS_SINE)
    _tween.tween_property(_label, "rect_position:y", -40.0, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
    _tween.set_loops()

func _exit_tree():
    _tween.kill()

func show_word(word: String) -> void:
    _reset()

    _word = word
    _label.bbcode_text = "[center]%s[/center]" % word
    yield(get_tree(), "idle_frame")
    _label.rect_pivot_offset = _label.rect_size / 2

    _show()

func show_success() -> void:
    _validated_count += 1
    _update_word_status()

func _update_word_status() -> void:
    var valid_word = _word.substr(0, _validated_count)
    var remaining_word = _word.substr(_validated_count)

    var remaining = ""
    if _failed:
        remaining = "[color=red]%s[/color]" % remaining_word
    else:
        remaining = remaining_word

    _label.bbcode_text = "[center][color=green]%s[/color]%s[/center]" % [valid_word, remaining]

func show_failure() -> void:
    _failed = true
    _update_word_status()

func _reset() -> void:
    _validated_count = 0
    _word = ""
    _label.bbcode_text = ""
    _failed = false

func fade_out() -> void:
    yield (_hide(), "completed")
    _reset()

func _show() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate", Color.white, 0.15)

func _hide() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate", Color.transparent, 0.15)
    yield(tween, "finished")
