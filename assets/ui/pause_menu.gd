extends Control

class_name PauseMenu


export(String) var main_menu_scene := "res://assets/level/main_menu.tscn"


onready var button_resume := $VBoxContainer/ButtonResume
onready var button_return_to_main_menu := $VBoxContainer/ButtonReturnToMainMenu
onready var button_quit := $VBoxContainer/ButtonQuit


signal on_resume


func _ready() -> void:
    assert(button_resume.connect("pressed", self, "_on_resume") == 0)
    assert(button_return_to_main_menu.connect("pressed", self, "_on_return_to_main_menu") == 0)
    assert(button_quit.connect("pressed", self, "_on_quit") == 0)
    _set_pause(true)


func _on_resume() -> void:
    emit_signal("on_resume")
    _set_pause(false)
    queue_free()


func _on_return_to_main_menu() -> void:
    _set_pause(false)
    get_tree().change_scene_to(load(main_menu_scene) as PackedScene)


func _on_quit() -> void:
    get_tree().quit(0)


func _set_pause(paused: bool) -> void:
    get_tree().paused = paused
