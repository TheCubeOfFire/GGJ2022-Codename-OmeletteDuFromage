extends Control

class_name HUD

onready var counter := $Counter as Label
onready var ready_label := $ReadyLabel as Label
onready var go_timer := $GoTimer as Timer


func _on_GoTimer_timeout() -> void:
    _hide_ready_go_label()


func set_counter_value(value: float) -> void:
    counter.text = "%.2f" % value

func set_go() -> void:
    ready_label.text = "Go!"
    go_timer.start()

func _hide_ready_go_label() -> void:
    ready_label.queue_free()
