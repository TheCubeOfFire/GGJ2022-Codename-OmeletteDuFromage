extends KinematicBody
class_name Player

const MAX_SPEED: float = 5.0

const MOUSE_SENSIVITY: float = 0.05

var _velocity := Vector3.ZERO

onready var _camera_target := $CameraTarget as Position3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	
	_velocity = MAX_SPEED * direction
	_velocity = move_and_slide(_velocity, Vector3.UP)

func _input(event: InputEvent) -> void:
	pass
