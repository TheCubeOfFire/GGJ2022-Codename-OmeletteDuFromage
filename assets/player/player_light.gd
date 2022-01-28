extends Spatial

class_name PlayerLight


export(NodePath) var light_path
onready var light := get_node(light_path) as OmniLight

export(float) var max_life := 100.0
export(float) var max_intensity := 1.0
export(float) var life_loss_per_second := 2.0


signal on_die


var current_life := max_life


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if current_life <= 0.0:
		return
		
	_update_current_life(delta)
	_update_light_intensity()
	
	if current_life <= 0.0:
		emit_signal("on_die")


func modify_life(modification: float) -> void:
	current_life += modification
	current_life = clamp(current_life, 0.0, max_life)


func _update_current_life(delta: float) -> void:
	modify_life(-life_loss_per_second * delta)


func _update_light_intensity() -> void:
	light.light_energy = max_intensity * (current_life/max_life)
