extends Spatial

class_name EndLevelTrigger


export(NodePath) var area_path
onready var area := get_node(area_path) as Area


signal triggered


func _ready() -> void:
    Utils.safe_connect(area, "body_entered", self, "_on_body_entered_area")


func _on_body_entered_area(body: Node) -> void:
    if body is Player:
       emit_signal("triggered")
