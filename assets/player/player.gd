extends KinematicBody
class_name Player

const MAX_SPEED: float = 5.0

const MOUSE_SENSIVITY: float = 0.05

var velocity := Vector3.ZERO

onready var camera_target := $CameraTarget as Position3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	
	velocity = MAX_SPEED * direction
	velocity = move_and_slide(velocity, Vector3.UP)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera(event.relative.y, event.relative.x, -MOUSE_SENSIVITY)

func _rotate_camera(rx: float, ry: float, scale: float) -> void:
	camera_target.rotate_x(deg2rad(rx * scale))
	camera_target.rotation.x = clamp(camera_target.rotation.x, - PI / 2.0, PI / 2.0)
	self.rotate_y(deg2rad(ry * scale))
