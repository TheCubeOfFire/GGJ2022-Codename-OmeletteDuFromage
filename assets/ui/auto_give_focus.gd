extends Node
class_name AutoGiveFocus

export var control_to_focus_path: NodePath

onready var control_to_focus := get_node(control_to_focus_path) as Control

func give_focus() -> void:
    if control_to_focus.get_focus_owner() == null:
        control_to_focus.grab_focus()
