extends Area2D
class_name Player

onready var _animation_player := $AnimationPlayer as AnimationPlayer

signal root_sensor_entered(root)
signal root_body_entered(root)
signal root_body_missed(root)

func kick() -> void:
    _animation_player.play("kick")
    yield(_animation_player, "animation_finished")

func walk() -> void:
    _animation_player.play("walk")

func fall() -> void:
    var sprite := $Sprite as Sprite
    var tween := get_tree().create_tween()

    _animation_player.play("sad")
    tween.tween_property(sprite, "position:y", sprite.texture.get_size().y / 2, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
    tween.parallel().tween_property(sprite, "rotation_degrees", 90.0, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)

func _ready() -> void:
    connect("area_shape_entered", self, "_on_area_shape_entered")
    connect("area_shape_exited", self, "_on_area_shape_exited")

func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int) -> void:
    if area is HarvestableRoot:
        var shape := area.shape_owner_get_owner(area_shape_index) as CollisionShape2D
        if shape.name == "Sensor":
            _on_root_sensor_collision(area)
        elif shape.name == "Body":
            _on_root_body_collision(area)

func _on_area_shape_exited(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int) -> void:
    if area is HarvestableRoot:
        var shape := area.shape_owner_get_owner(area_shape_index) as CollisionShape2D
        if shape.name == "Body":
            _on_root_missed(area)

func _on_root_sensor_collision(root: HarvestableRoot) -> void:
    emit_signal("root_sensor_entered", root)

func _on_root_body_collision(root: HarvestableRoot) -> void:
    emit_signal("root_body_entered", root)

func _on_root_missed(root: HarvestableRoot) -> void:
    emit_signal("root_body_missed", root)
