extends Node

var game_has_control := false

func take_control() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    game_has_control = true

func release_control() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    game_has_control = false

func _input(event: InputEvent) -> void:
    if not game_has_control:
        return

    if event is InputEventMouseButton:
        var event_mouse_button := event as InputEventMouseButton
        if event_mouse_button.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
