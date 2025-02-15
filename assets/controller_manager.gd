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
        get_tree().call_group("auto_give_focus", "give_focus")
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    game_has_control = false

func _ready() -> void:
    var pause_input_key := InputEventKey.new()
    if OS.has_feature("web"):
        pause_input_key.scancode = KEY_P
    else:
        pause_input_key.scancode = KEY_ESCAPE
    InputMap.action_add_event("ui_pause_menu", pause_input_key)
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

        if event.is_action_pressed("retry"):
            Utils.safe_reload_current_scene(get_tree())
    else:
        if not using_gamepad and event is InputEventJoypadButton:
            using_gamepad = true
            Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
            get_tree().call_group("auto_give_focus", "give_focus")
        elif using_gamepad and event is InputEventMouse:
            using_gamepad = false
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
