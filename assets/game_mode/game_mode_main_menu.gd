extends Node

const HUE_VARIATION_FACTOR: float = 0.7
const SATURATION_VARIATION_FACTOR: float = 0.2

var blobMeshInstance : MeshInstance

onready var persistent_data := get_node("/root/PersistentData") as PersistentData

export(PackedScene) var pause_menu_class: PackedScene
var pause_menu: PauseMenu

var active := true

var hue := 0.0
var saturation_param := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
    blobMeshInstance = find_node("blobMeshInstance", true)
    assert(null != blobMeshInstance)
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
    
    var material_blob := blobMeshInstance.get_surface_material(0) as ShaderMaterial
    material_blob.set_shader_param("albedo", persistent_data.player_color)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_pause_menu") && active:
        _spawn_pause_menu()
        
func _spawn_pause_menu() -> void:
    pause_menu = pause_menu_class.instance() as PauseMenu
    add_child(pause_menu)
    assert(pause_menu.connect("on_resume", self, "_resume_game") == 0)
    active = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _resume_game() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    active = true
