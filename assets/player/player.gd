extends KinematicBody
class_name Player

const DASH_SPEED: float = 3.0
const DRAG_FACTOR: float = 0.02
const JUMP_SPEED: float = 3.0

const MASS: float = 100.0
const GRAVITY: float = 9.81

const MOUSE_SENSIVITY: float = 5.0
const PAD_SENSIVITY: float = 250.0

var velocity := Vector3.ZERO
var can_dash := true

var block_inputs := false

onready var persistent_data := get_node("/root/PersistentData") as PersistentData

export var pad_rotation_deadzone_threshold : float = 0.25

onready var camera_target := $CameraTarget as CameraTarget
onready var player_light := $PlayerLight as PlayerLight
onready var dash_timer := $DashTimer as Timer
onready var dash_particles := $DashParticles as CPUParticles
onready var blob_mesh_instance := $blobMeshInstance as MeshInstance


func _on_DashTimer_timeout() -> void:
    _enable_dash()


func _ready() -> void:
    if not OS.has_feature("web"):
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    if persistent_data.color_chosen:
        update_color()

func _process(_delta: float) -> void:
    var axis_0_x = Input.get_joy_axis(0, JOY_AXIS_1)
    var axis_0_y = Input.get_joy_axis(0, JOY_AXIS_0)
    if abs(axis_0_x) > pad_rotation_deadzone_threshold or abs(axis_0_y) > pad_rotation_deadzone_threshold:
       _rotate_camera(axis_0_x, axis_0_y, -PAD_SENSIVITY * get_physics_process_delta_time())

func _physics_process(delta: float) -> void:
    var drag := (-DRAG_FACTOR * velocity.length() / MASS) * velocity

    if not block_inputs and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if is_on_floor() && can_dash && Input.is_action_pressed("dash"):
            _dash()

    velocity += GRAVITY * Vector3.DOWN * delta

    velocity = move_and_slide(velocity, Vector3.UP)
    if is_on_floor():
        velocity = Vector3.ZERO
    else:
        velocity += drag * delta

func _input(event: InputEvent) -> void:
    if not block_inputs and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion:
            _rotate_camera(event.relative.y, event.relative.x, -MOUSE_SENSIVITY * get_physics_process_delta_time())

func _dash() -> void:
    var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
    camera_target.start_dash_effect()
    can_dash = false
    dash_particles.emitting = true
    dash_timer.start()
    velocity += direction * DASH_SPEED + Vector3.UP * JUMP_SPEED
    $DashStreamPlayer.play()

func _rotate_camera(rx: float, ry: float, scale: float) -> void:
    camera_target.rotate_camera(rx, scale)
    self.rotate_y(deg2rad(ry * scale))

func _enable_dash() -> void:
    camera_target.stop_dash_effect()
    dash_particles.emitting = false
    can_dash = true

func absorb_light_play_sound() -> void:
    $EatLightSoundPlayer.play()

func update_color() -> void:
    var material_blob := blob_mesh_instance.get_surface_material(0) as ShaderMaterial
    material_blob.set_shader_param("albedo", persistent_data.player_color)
    var particles_material := dash_particles.mesh.surface_get_material(0) as SpatialMaterial
    particles_material.emission = Color(persistent_data.player_color.x, persistent_data.player_color.y, persistent_data.player_color.z)
