extends Spatial

class_name LoadLevelTrigger


export(NodePath) var area_path
onready var area := get_node(area_path) as Area

export(PackedScene) var level_to_load: PackedScene


func _ready() -> void:
	assert(area.connect("body_entered", self, "_on_area_entered") == 0)


func _on_area_entered(node: Node) -> void:
	if node is Player:
		get_tree().change_scene_to(level_to_load)
