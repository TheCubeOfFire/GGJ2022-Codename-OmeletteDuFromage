extends Control

class_name PauseMenu


export(String) var main_menu_scene := "res://assets/level/main_menu.tscn"


onready var button_resume := $VBoxContainer/ButtonResume
onready var button_return_to_main_menu := $VBoxContainer/ButtonReturnToMainMenu
onready var button_quit := $VBoxContainer/ButtonQuit


signal resume


func _on_ButtonResume_pressed() -> void:
    emit_signal("resume")
    _set_pause(false)
    queue_free()

func _on_ButtonReturnToMainMenu_pressed() -> void:
    _set_pause(false)
    Utils.safe_change_scene(get_tree(), main_menu_scene)

func _on_ButtonQuit_pressed() -> void:
    get_tree().quit(0)


func _ready() -> void:
    _set_pause(true)

func _set_pause(paused: bool) -> void:
    get_tree().paused = paused
