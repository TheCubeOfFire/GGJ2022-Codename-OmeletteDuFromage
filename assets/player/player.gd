extends KinematicBody
class_name Player

const DASH_ACCELERATION: float = 3000.0
const DRAG_FACTOR: float = 10.0

const MOUSE_SENSIVITY: float = 5.0

var velocity := Vector3.ZERO

onready var camera_target := $CameraTarget as Position3D
onready var player_light := $PlayerLight as PlayerLight

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)

	var drag := -DRAG_FACTOR * velocity

	if Input.is_action_just_pressed("dash"):
		velocity += DASH_ACCELERATION * direction * delta

	velocity = move_and_slide(velocity, Vector3.UP)
	velocity += drag * delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera(event.relative.y, event.relative.x, -MOUSE_SENSIVITY * get_physics_process_delta_time())

func _rotate_camera(rx: float, ry: float, scale: float) -> void:
	camera_target.rotate_x(deg2rad(rx * scale))
	camera_target.rotation.x = clamp(camera_target.rotation.x, - PI / 2.0, PI / 2.0)
	self.rotate_y(deg2rad(ry * scale))
