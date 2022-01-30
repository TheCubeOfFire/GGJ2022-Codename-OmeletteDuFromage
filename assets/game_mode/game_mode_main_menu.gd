extends Node


# Declare member variables here. Examples:
var blobMeshInstance : MeshInstance

var sleep_duration : float = 5
var sleep_elapsed_time : float = 0.0
var sleeping : bool = false

var color_r_value : float = 0.0
var color_g_value : float = 0.0
var color_b_value : float = 0.0

var color_variation_factor : float = 0.1
var color_variation_threshold : float = 1.0

onready var persistent_data := get_node("/root/PersistentData") as PersistentData

export(PackedScene) var pause_menu_class: PackedScene
var pause_menu: PauseMenu

var active := true

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
        
    sleep_elapsed_time += delta
    if sleep_elapsed_time > sleep_duration:
        sleeping = false
        sleep_elapsed_time = 0.0
    
    if sleeping:
        return    
    
    if not color_variation_factor + color_r_value + color_g_value + color_b_value > color_variation_threshold:
        color_r_value += color_variation_factor
    else :
        color_r_value = 0.0
        if not color_variation_factor + color_g_value + color_b_value > color_variation_threshold:
            color_g_value += color_variation_factor
        else:
            color_g_value = 0.0
            if not color_variation_factor + color_b_value > color_variation_threshold:
                color_b_value += color_variation_factor
            else:
                color_r_value = 0.0
                color_g_value = 0.0
                color_b_value = 0.0
            
    
    var new_color := Vector3(color_r_value, color_g_value, color_b_value)
    var material_blob := blobMeshInstance.get_surface_material(0) as ShaderMaterial
    material_blob.set_shader_param("albedo", new_color)

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
