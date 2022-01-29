extends KinematicBody
class_name Player

const DASH_ACCELERATION: float = 600.0
const DRAG_FACTOR: float = 2.0

const MOUSE_SENSIVITY: float = 5.0

var velocity := Vector3.ZERO
var can_dash := true

onready var camera_target := $CameraTarget as CameraTarget
onready var player_light := $PlayerLight as PlayerLight
onready var dash_timer := $DashTimer as Timer
onready var dash_particles := $DashParticles as CPUParticles

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    var connect_error := dash_timer.connect("timeout", self, "_enable_dash")
    if connect_error != OK:
        push_error("Error connecting dash timer")

func _physics_process(delta: float) -> void:
    var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)

    var drag := -DRAG_FACTOR * velocity

    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if can_dash and Input.is_action_just_pressed("dash"):
            camera_target.start_dash_effect()
            can_dash = false
            dash_particles.emitting = true
            dash_timer.start()
            velocity += DASH_ACCELERATION * direction * delta

    velocity = move_and_slide(velocity, Vector3.UP)
    velocity += drag * delta

func _input(event: InputEvent) -> void:
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            _rotate_camera(event.relative.y, event.relative.x, -MOUSE_SENSIVITY * get_physics_process_delta_time())

func _rotate_camera(rx: float, ry: float, scale: float) -> void:
    camera_target.rotate_camera(rx, scale)
    self.rotate_y(deg2rad(ry * scale))

func _enable_dash() -> void:
    camera_target.stop_dash_effect()
    dash_particles.emitting = false
    can_dash = true
