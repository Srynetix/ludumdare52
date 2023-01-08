extends Node2D

onready var _message := $CanvasLayer/MarginContainer/Message as PopupText
onready var _audio_stream := $AudioStreamPlayer as AudioStreamPlayer
onready var _item_container := $Items as Node2D
onready var _shade := $Shade as Shade

var _remaining_items_to_spawn: Array = []
var _timer: Timer

func _ready() -> void:
    _timer = Timer.new()
    _timer.wait_time = 0.1
    _timer.one_shot = false
    _timer.autostart = true
    _timer.connect("timeout", self, "_try_spawn_item")
    add_child(_timer)

    _shade.update_round(GameData.get_round())
    for item in GameData.get_picked_items():
        _remaining_items_to_spawn.append(item)

    if GameData.get_score() >= GameData.get_highscore():
        GameData.set_highscore(GameData.get_score())

func _simulate_items(round_hits: int, rounds: int) -> void:
    GameData.reset_game()
    GameData.set_round(rounds)

    for _rd in range(rounds):
        for _hit in range(round_hits):
            GameData.add_picked_item(RootItemType.random_item_type())

func _try_spawn_item() -> void:
    if _remaining_items_to_spawn.empty():
        _timer.stop()
        _start_message()
        return

    var item_type := _remaining_items_to_spawn.pop_back() as int
    _spawn_item(item_type)

func _start_message() -> void:
    yield(get_tree().create_timer(2), "timeout")
    _show_message()

func _show_message() -> void:
    var item_count := len(GameData.get_picked_items())
    var win := false
    
    if item_count == 0:
        _message.show_text("[center][shake]Are you kidding me?\n\nThere's nothing in there, let's go![/shake][/center]")
    elif item_count < 20:
        _message.show_text("[center][shake]Uhhhhh... That's it?\n\nWe can do better![/shake][/center]")
    elif item_count < 40:
        _message.show_text("[center][shake]That's still not enough.\n\nWE NEED MORE FOOD![/shake][/center]")
    elif item_count < 60:
        _message.show_text("[center][shake]Almost there!\nnA few dozen more should be enough![/shake][/center]")
    else:
        _message.delay = 10
        _message.show_text("[center][rainbow]THERE WE GO![/rainbow]\n\nThanks dude!\n\nFinally, something\n to eat in this\nhouse![/center]")
        win = true

    yield(get_tree().create_timer(_message.delay + 2), "timeout")

    var speed = 2
    if win:
        speed = 1
    GameSceneTransitioner.fade_to_scene_path("res://screens/Title.tscn", speed)

func _spawn_item(item_type: int) -> void:
    var spawn_pos := $SpawnPosition as Position2D
    var body := RigidBody2D.new()
    body.gravity_scale = 3.0
    body.contact_monitor = true
    body.contacts_reported = 1
    body.connect("body_entered", self, "_on_body_hit", [body])

    var collision_shape := CollisionShape2D.new()
    var shape := CircleShape2D.new()
    shape.radius = 12 * 1.25
    collision_shape.shape = shape
    body.add_child(collision_shape)

    var sprite := Sprite.new()
    var texture := RootItemType.get_texture(item_type)
    sprite.texture = texture
    sprite.scale = Vector2(1.25, 1.25)
    body.add_child(sprite)

    _item_container.add_child(body)
    body.position = spawn_pos.position + Vector2.RIGHT * rand_range(-10, 10)

func _on_body_hit(_body: PhysicsBody2D, this_body: RigidBody2D) -> void:
    _audio_stream.play()

    # Enough!
    this_body.set_deferred("contact_monitor", false)
