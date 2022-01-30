extends CPUParticles
class_name LightParticles

onready var timer := $Timer as Timer

func _on_Timer_timeout() -> void:
    queue_free()
