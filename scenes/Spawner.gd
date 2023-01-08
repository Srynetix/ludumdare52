extends Node2D
class_name Spawner

export var scene: PackedScene
export var auto_spawn_wait_time := 0.0 

var _auto_spawn_timer: Timer

signal instance_spawned(instance)

func _ready():
    _auto_spawn_timer = Timer.new()
    _auto_spawn_timer.wait_time = auto_spawn_wait_time
    _auto_spawn_timer.one_shot = false
    _auto_spawn_timer.autostart = false
    _auto_spawn_timer.connect("timeout", self, "spawn")
    add_child(_auto_spawn_timer)

func start_auto_spawn() -> void:
    _auto_spawn_timer.start()

func stop_auto_spawn() -> void:
    _auto_spawn_timer.stop()

func spawn() -> void:
    var instance := scene.instance()
    emit_signal("instance_spawned", instance)