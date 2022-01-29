extends Spatial

class_name EatableLight

# Max life that can ever be given by an eatable light
const MAX_GIVEN_LIFE := 100.0


export(NodePath) var area_path
onready var area := get_node(area_path) as Area

export(NodePath) var light_path
onready var light := get_node(light_path) as Light

export(Curve) var light_intensity_curve: Curve = null
export(float) var given_life := 5.0


func _ready() -> void:
    assert(given_life <= MAX_GIVEN_LIFE)
    assert(area.connect("body_entered", self, "_on_area_entered") == 0)
    _update_light_intensity()

    
func _update_light_intensity() ->  void:
    light.light_energy = light_intensity_curve.interpolate(given_life / MAX_GIVEN_LIFE)
    

func _on_area_entered(body: Node) -> void:
    if body is Player:
        var player := body as Player
        player.player_light.modify_life(given_life)
        queue_free()
