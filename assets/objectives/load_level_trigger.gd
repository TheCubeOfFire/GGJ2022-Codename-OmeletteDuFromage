extends Spatial

class_name LoadLevelTrigger


export(NodePath) var area_path
onready var area := get_node(area_path) as Area

export(PackedScene) var level_to_load: PackedScene


func _ready() -> void:
    Utils.safe_connect(area, "body_entered", self, "_on_area_entered")


func _on_area_entered(node: Node) -> void:
    if node is Player:
        Utils.safe_change_scene_to(get_tree(), level_to_load)
