extends Control

class_name DeathScreen


signal on_retry_pressed


func _ready():
    assert($VBoxContainer/ButtonRetry.connect("pressed", self, "_on_retry_pressed") == 0)


func _on_retry_pressed() -> void:
    emit_signal("on_retry_pressed")
