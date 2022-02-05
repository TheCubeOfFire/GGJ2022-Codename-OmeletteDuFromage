extends Node

var game_has_control := false
var using_gamepad := false

func take_control() -> void:
    if not using_gamepad:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    game_has_control = true

func release_control() -> void:
    if using_gamepad:
        Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    game_has_control = false

func _ready() -> void:
    pause_mode = PAUSE_MODE_PROCESS

func _input(event: InputEvent) -> void:
    if game_has_control:
        if event is InputEventMouseButton:
            using_gamepad = false
            var event_mouse_button := event as InputEventMouseButton
            if event_mouse_button.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        elif event is InputEventJoypadButton:
            using_gamepad = true
    else:
        if not using_gamepad and event is InputEventJoypadButton:
            using_gamepad = true
            Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
            get_tree().call_group("auto_give_focus", "give_focus")
        elif using_gamepad and event is InputEventMouse:
            using_gamepad = false
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
