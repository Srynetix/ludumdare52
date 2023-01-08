extends Control

func _ready() -> void:
    GameSceneTransitioner.fade_to_scene_path("res://screens/Title.tscn", 2)