extends Node

var player_color: Color
var total_score := 0.0
var color_chosen : bool = false

func _ready() -> void:
    reset()

func reset() -> void:
    player_color = Color.white
    total_score = 0.0
    color_chosen = false
