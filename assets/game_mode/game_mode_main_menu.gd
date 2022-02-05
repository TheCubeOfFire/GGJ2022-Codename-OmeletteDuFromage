extends Node
class_name GameModeMainMenu

const HUE_VARIATION_FACTOR: float = 0.7
const SATURATION_VARIATION_FACTOR: float = 0.2

onready var persistent_data := get_node("/root/PersistentData") as PersistentData
onready var controller_manager := get_node("/root/ControllerManager") as ControllerManager
onready var player := $Player as Player

export(PackedScene) var pause_menu_class: PackedScene
var pause_menu: PauseMenu

var active := true

var hue := 0.0
var saturation_param := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
    var playerLight = find_node("PlayerLight", true) as PlayerLight
    assert(null != playerLight)
    playerLight.set_invincible(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not active:
        return

    if persistent_data.color_chosen:
        return

    if Input.is_action_just_pressed("dash"):
        persistent_data.color_chosen = true
        return

    hue = fmod(hue + delta * HUE_VARIATION_FACTOR, 1.0)
    saturation_param = fmod(saturation_param + delta * SATURATION_VARIATION_FACTOR, 1.0)
    var saturation := (sin(saturation_param * 2 * PI) + 1.0) / 2.0
    assert(0.0 <= saturation && saturation <= 1.0)
    var new_color := Color.from_hsv(hue, saturation, 1.0)

    persistent_data.player_color = Vector3(new_color.r, new_color.g, new_color.b)
    player.update_color()


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_pause_menu") && active:
        _spawn_pause_menu()

func _spawn_pause_menu() -> void:
    pause_menu = pause_menu_class.instance() as PauseMenu
    add_child(pause_menu)
    Utils.safe_connect(pause_menu, "resume", self, "_resume_game")
    active = false
    controller_manager.release_control()

func _resume_game() -> void:
    controller_manager.take_control()
    active = true
