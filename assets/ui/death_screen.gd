extends Control

class_name DeathScreen


signal retry_pressed


func _on_ButtonRetry_pressed() -> void:
    emit_signal("retry_pressed")
