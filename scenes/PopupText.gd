extends RichTextLabel
class_name PopupText

signal finished()

export var autostart: bool = false
export var delay: float = 5.0
export var autohide: bool = true

func _ready():
    modulate = Color.transparent

    if autostart:
        _show_anim()
    
func show_text(text: String) -> void:
    bbcode_text = text
    _show_anim()

func _show_anim() -> void:
    # Reset
    modulate = Color.transparent

    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate", Color.white, 0.5)
    tween.tween_interval(delay)
    if autohide:
        tween.tween_property(self, "modulate", Color.transparent, 0.5)

    yield(tween, "finished")
    emit_signal("finished")