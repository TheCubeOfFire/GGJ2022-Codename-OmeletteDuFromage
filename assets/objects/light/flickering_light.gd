extends SpotLight

class_name FlickeringLight

# Declare member variables here. Examples:
export var flicker_enabled : bool = false
export var flicker_threshold_random : float = 0
var flicker_threshold : float = 0
export var curve : Curve
export var curve_time_scale : float = 1
var flicker_duration = 2
var flicker_elapsed_time_on = 0

var light_energy_init = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
    light_energy_init = self.light_energy
    flicker_threshold = rand_range(0.0, flicker_threshold_random)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void :
    if not flicker_enabled:
        return

    flicker_elapsed_time_on += delta;
    if flicker_elapsed_time_on > flicker_threshold:
        if flicker_elapsed_time_on > flicker_threshold + curve_time_scale:
            flicker_elapsed_time_on = 0.0;
            light_energy = light_energy_init
            flicker_threshold = rand_range(0.0, flicker_threshold_random)
        else:
            var curve_pos = (flicker_elapsed_time_on - flicker_threshold) * curve_time_scale
            light_energy = light_energy_init if curve.interpolate(curve_pos) > 0.5 else 0.0
