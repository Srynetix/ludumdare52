extends CPUParticles2D


func _ready():
    one_shot = true
    yield(get_tree().create_timer(0.85), "timeout")
    queue_free()