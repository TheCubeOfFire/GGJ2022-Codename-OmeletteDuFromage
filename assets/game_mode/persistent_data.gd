extends Node

var player_color: Vector3
var total_score := 0.0
var color_chosen : bool = false

func _ready() -> void:
    reset()

func reset() -> void:
    player_color = Vector3.ZERO
    total_score = 0.0
    color_chosen = false
