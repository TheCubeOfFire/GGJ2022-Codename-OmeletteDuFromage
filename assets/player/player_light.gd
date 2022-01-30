extends Spatial

class_name PlayerLight


export(NodePath) var light_path
onready var light := get_node(light_path) as OmniLight

export(Curve) var light_intensity_curve: Curve = null
export(float) var max_life := 100.0
export(float) var life_loss_per_second := 2.0


signal on_die

var invincible : bool = false
var current_life := max_life
var current_speed : float;
var max_speed : float;
var origin_scale : Vector3;

func _ready() -> void:
    var coreNode = get_parent().get_child(0).get_child(0) as Spatial;
    current_speed = coreNode.get("maxSpeed");
    max_speed = current_speed;
    origin_scale = coreNode.get_scale();

func _process(delta: float) -> void:
    if current_life <= 0.0:
        return
        
    _update_current_life(delta)
    _update_light_intensity()
    _update_speed_core()
    _update_core_scale()
    
    
    if current_life <= 0.0:
        emit_signal("on_die")


func modify_life(modification: float) -> void:
    if not invincible:
        current_life += modification
        current_life = clamp(current_life, 0.0, max_life)


func _update_current_life(delta: float) -> void:
    modify_life(-life_loss_per_second * delta)


func _update_light_intensity() -> void:
    light.light_energy = light_intensity_curve.interpolate(current_life / max_life)
    
func _update_speed_core() -> void:
    var coreNode = get_parent().get_child(0).get_child(0);
    current_speed = max_speed * current_life / max_life;
    coreNode.set("maxSpeed", current_speed);
    
func _update_core_scale() -> void:
    var coreNode = get_parent().get_child(0).get_child(0) as Spatial;
    coreNode.scale = origin_scale * current_life / max_life;
    coreNode.scale.x = max(coreNode.scale.x, 0.1);
    coreNode.scale.y = max(coreNode.scale.y, 0.1);
    coreNode.scale.z = max(coreNode.scale.z, 0.1);
    
func set_invincible(_invincible: bool) -> void:
    invincible = _invincible
