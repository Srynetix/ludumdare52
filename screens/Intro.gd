extends Node2D

onready var _text := $CanvasLayer/CenterContainer/PopupText as PopupText
onready var _camera := $Camera2D as Camera2D
onready var _player := $Sprite as AnimatedSprite
onready var _player_head := $PlayerHead as Position2D
onready var _foooood := $CanvasLayer/CenterContainer/EEEEEEE as RichTextLabel
onready var _fx_player := $FxPlayer as FxPlayer

func _ready() -> void:
    GameGlobalMusicPlayer.play_stream(GameScreen.TRACK_1)

    yield(get_tree().create_timer(1.0), "timeout")
    _text.delay = 1.0
    _text.show_text("[center][wave]Hmmm...[/wave][/center]")
    yield(_text, "finished")

    var tween = get_tree().create_tween()
    tween.tween_property(_camera, "zoom", Vector2(0.5, 0.5), 0.25).set_trans(Tween.TRANS_QUAD)
    tween.parallel().tween_property(_camera, "position", _player.position, 0.25).set_trans(Tween.TRANS_QUAD)
    yield(tween, "finished")

    _text.delay = 0.5
    _text.show_text("[center][wave]I...[/wave][/center]")
    yield(_text, "finished")

    var tween2 = get_tree().create_tween()
    tween2.tween_property(_camera, "zoom", Vector2(0.15, 0.15), 0.25).set_trans(Tween.TRANS_QUAD)
    tween2.parallel().tween_property(_camera, "position", _player_head.position, 0.25).set_trans(Tween.TRANS_QUAD)
    yield(tween2, "finished")

    _text.delay = 0.5
    _text.show_text("[center][wave]NEED...[/wave][/center]")
    yield(_text, "finished")

    var tween3 = get_tree().create_tween()
    tween3.tween_property(_camera, "zoom", Vector2(1, 1), 0.25).set_trans(Tween.TRANS_QUAD)
    tween3.parallel().tween_property(_camera, "position", Vector2(512, 300), 0.25).set_trans(Tween.TRANS_QUAD)
    yield(tween3, "finished")

    _foooood.visible = true
    var tween4 = get_tree().create_tween()
    tween4.set_ease(Tween.EASE_IN_OUT)
    tween4.tween_property(_foooood, "rect_position:x", -6000.0, 2.0).set_trans(Tween.TRANS_SINE)
    yield(tween4, "finished")

    var tween5 = get_tree().create_tween()
    tween5.tween_interval(2)
    tween5.tween_property(_foooood, "modulate", Color.transparent, 1.0)
    tween5.tween_property(_foooood, "visible", false, 0.0)
    yield(tween5, "finished")

    _player.animation = "walk"
    _text.show_text("[center][wave]LET'S GO![/wave][/center]")
    yield(_text, "finished")

    var tween6 = get_tree().create_tween()
    tween6.set_ease(Tween.EASE_IN_OUT)
    tween6.tween_property(_player, "position:x", 800.0, 0.5).as_relative().set_trans(Tween.TRANS_QUAD)
    tween6.tween_callback(self, "_boom")
    yield(tween6, "finished")

    GameGlobalMusicPlayer.fade_out(0.25)
    GameData.set_intro_already_seen(true)
    GameSceneTransitioner.fade_to_scene_path("res://screens/Game.tscn")
    
func _boom() -> void:
    _fx_player.play_fx(FxPlayer.FxEnum.Fall)
