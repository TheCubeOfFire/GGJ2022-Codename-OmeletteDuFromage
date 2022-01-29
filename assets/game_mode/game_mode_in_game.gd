extends Spatial

class_name GameModeInGame

export(NodePath) var player_start_path
onready var player_start := get_node(player_start_path) as Spatial

export(NodePath) var end_level_path
onready var end_level := get_node(end_level_path) as EndLevelTrigger

export(PackedScene) var next_scene: PackedScene
export(PackedScene) var player_class: PackedScene
export(PackedScene) var hud_class: PackedScene


var player: Player
var hud: HUD

var current_counter_value := 0.0


func _ready() -> void:
	_spawn_hud()
	_spawn_player()
	_register_to_end_level()


func _process(delta: float) -> void:
	_update_time_counter(delta)


func _spawn_hud() -> void:
	hud = hud_class.instance() as HUD
	add_child(hud)


func _spawn_player() -> void:
	player = player_class.instance() as Player
	add_child(player)
	
	assert(player.player_light.connect("on_die", self, "_on_die") == 0)
	
	if player_start != null:
		player.transform = player_start.transform


func _register_to_end_level() -> void:
	assert(end_level != null)
	assert(end_level.connect("on_triggered", self, "_on_end_level_triggered") == 0)


func _update_time_counter(delta: float) -> void:
	current_counter_value += delta
	hud.set_counter_value(current_counter_value)

func _on_die() -> void:
	_retry_current_level()


func _on_end_level_triggered() -> void:
	_proceed_to_next_scene()


func _proceed_to_next_scene() -> void:
	if next_scene != null:
		assert(get_tree().change_scene_to(next_scene) == 0)
	else:
		print("No next scene to load !")


func _retry_current_level() -> void:
	assert(get_tree().reload_current_scene() == 0)
