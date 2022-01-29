extends Control

class_name HUD

onready var counter := $Counter as Label


func _ready():
    pass


func set_counter_value(value: float) -> void:
    counter.text = "%.2f" % value
