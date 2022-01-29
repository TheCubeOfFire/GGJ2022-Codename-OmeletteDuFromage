extends Spatial

class_name EndLevelTrigger


export(NodePath) var area_path
onready var area := get_node(area_path) as Area


signal on_triggered


func _ready() -> void:
	var _connect_error := area.connect("body_entered", self, "_on_body_entered_area")
	

func _on_body_entered_area(_body: Node) -> void:
	emit_signal("on_triggered")
