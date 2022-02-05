extends ColorRect
class_name EntryPoint

onready var main_menu_scene := preload("res://assets/level/main_menu.tscn") as PackedScene

func _on_PlayButton_pressed() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    Utils.safe_change_scene_to(get_tree(), main_menu_scene)
