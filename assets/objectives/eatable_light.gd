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

onready var light_particles_scene := preload("res://assets/player/light_particles.tscn") as PackedScene

func _ready() -> void:
    assert(given_life <= MAX_GIVEN_LIFE)
    assert(area.connect("body_entered", self, "_on_area_entered") == 0)
    _update_light_intensity()

    
func _update_light_intensity() ->  void:
    light.light_energy = light_intensity_curve.interpolate(given_life / MAX_GIVEN_LIFE)
    
    if light is FlickeringLight:
        var flickering_light := light as FlickeringLight
        flickering_light.light_energy_init = light.light_energy
    

func _on_area_entered(body: Node) -> void:
    if body is Player:
        var player := body as Player
        player.absorb_light_play_sound()
        player.player_light.modify_life(given_life)
        var light_particles := light_particles_scene.instance()
        player.add_child(light_particles)
        queue_free()
