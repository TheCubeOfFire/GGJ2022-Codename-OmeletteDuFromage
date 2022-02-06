extends Control

class_name PauseMenu


export(String) var main_menu_scene := "res://assets/level/main_menu.tscn"
export(String) var entry_point_scene := "res://assets/ui/entry_point.tscn"


onready var button_resume := $VBoxContainer/ButtonResume
onready var button_return_to_main_menu := $VBoxContainer/ButtonReturnToMainMenu
onready var button_quit := $VBoxContainer/ButtonQuit
onready var persistent_data := get_node("/root/PersistentData") as PersistentData


signal resume


func _on_ButtonResume_pressed() -> void:
    _resume()

func _on_ButtonReturnToMainMenu_pressed() -> void:
    _set_pause(false)
    Utils.safe_change_scene(get_tree(), main_menu_scene)

func _on_ButtonQuit_pressed() -> void:
    if OS.has_feature("entry_point"):
        _set_pause(false)
        persistent_data.reset()
        Utils.safe_change_scene(get_tree(), entry_point_scene)
    else:
        get_tree().quit(0)


func _ready() -> void:
    _set_pause(true)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_pause_menu"):
        get_tree().set_input_as_handled()
        _resume()

func _resume() -> void:
    emit_signal("resume")
    _set_pause(false)
    queue_free()

func _set_pause(paused: bool) -> void:
    get_tree().paused = paused
