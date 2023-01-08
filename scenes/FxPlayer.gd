extends AudioStreamPlayer
class_name FxPlayer

const FALL_SOUND = preload("res://assets/sounds/fall.wav")
const FAIL_SOUND = preload("res://assets/sounds/fail.wav")
const KICK_SOUND = preload("res://assets/sounds/kick.wav")
const SUCCESS_SOUND = preload("res://assets/sounds/success.wav")
const APPEAR_SOUND = preload("res://assets/sounds/appear.wav")

enum FxEnum {
    Fall = 0,
    Fail,
    Kick,
    Success,
    Appear,
}

func _get_stream_from_fx(fx_type: int) -> AudioStream:
    match fx_type:
        FxEnum.Fall:
            return FALL_SOUND
        FxEnum.Fail:
            return FAIL_SOUND
        FxEnum.Kick:
            return KICK_SOUND
        FxEnum.Success:
            return SUCCESS_SOUND
        FxEnum.Appear:
            return APPEAR_SOUND
    return null

func play_fx(fx_type: int) -> void:
    stop()
    stream = _get_stream_from_fx(fx_type)
    play()
