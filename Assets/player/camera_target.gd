extends Position3D
class_name CameraTarget

onready var camera := $SpringArm/Camera as Camera
onready var tween := $Tween as Tween

func rotate_camera(rx: float, scale: float) -> void:
    rotate_x(deg2rad(rx * scale))
    rotation.x = clamp(rotation.x, - PI / 2.0, PI / 2.0)

func start_dash_effect() -> void:
    tween.stop_all()
    tween.remove_all()
    tween.interpolate_property(camera, "fov", null, 100.0, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
    tween.start()

func stop_dash_effect() -> void:
    tween.stop_all()
    tween.remove_all()
    tween.interpolate_property(camera, "fov", null, 70.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    tween.start()
