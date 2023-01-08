extends ColorRect
class_name Shade

const MAX_ROUND := 5

func update_round(round_idx: int) -> void:
    color = _get_target_color(round_idx)

func update_round_animate(round_idx: int) -> void:
    var tween := get_tree().create_tween()
    tween.tween_property(self, "color", _get_target_color(round_idx), 1.0)

func _get_target_color(round_idx: int) -> Color:
    var coef = min(round_idx - 1, MAX_ROUND) / float(MAX_ROUND)
    return SxColor.with_alpha_f(Color8(20, 17, 59), coef * 0.70)