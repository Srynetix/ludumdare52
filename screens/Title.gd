extends Control

onready var _hs_value := $MarginContainer/HighScoreContainer/HighScoreValue as Label
onready var _erase_data_dialog := $EraseDataDialog as SxFullScreenConfirmationDialog

func _ready() -> void:
    _hs_value.text = "%s %d" % [GameData.get_highscore_owner(), GameData.get_highscore()]
    _erase_data_dialog.connect("confirmed", self, "_clear_data")

func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        var event_key := event as InputEventKey
        if event_key.pressed && event_key.scancode == KEY_ENTER:
            set_process_input(false)

            if GameData.is_intro_already_seen():
                GameSceneTransitioner.fade_to_scene_path("res://screens/Game.tscn", 2)
            else:
                GameSceneTransitioner.fade_to_scene_path("res://screens/Intro.tscn", 2)

        elif event_key.pressed && event_key.scancode == KEY_F10:
            _erase_data_dialog.show()

func _clear_data() -> void:
    GameData.clear_all()
    GameData.persist_to_disk()
    GameData.reset_game()
    GameSceneTransitioner.fade_to_scene_path("res://screens/Title.tscn", 2)