extends Spatial

class_name GameModeInGame

export(NodePath) var player_start_path
onready var player_start := get_node(player_start_path) as Spatial

export(NodePath) var end_level_path
onready var end_level := get_node(end_level_path) as EndLevelTrigger

export(PackedScene) var next_scene: PackedScene
export(PackedScene) var player_class: PackedScene


var player: Player


func _ready() -> void:
	player = player_class.instance() as Player
	add_child(player)
	
	if player_start != null:
		player.transform = player_start.transform
		
	assert(end_level != null)
	end_level.connect("on_triggered", self, "_on_end_level_triggered")


func _process(delta: float) -> void:
	pass


func _on_end_level_triggered() -> void:
	pass


func _proceed_to_next_scene() -> void:
	if next_scene != null:
		assert(get_tree().change_scene_to(next_scene) == 0)


func _retry_current_level() -> void:
	assert(get_tree().reload_current_scene() == 0)
