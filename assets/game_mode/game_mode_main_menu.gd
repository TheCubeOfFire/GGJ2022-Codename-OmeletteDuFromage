extends Node


# Declare member variables here. Examples:
var blobMeshInstance : MeshInstance
var color_tmp : Array = [0.0, 0.0, 0.0]
var current_color_index : int = 0
var sleep_duration : float = 0.1
var sleep_elapsed_time : float = 0.0
var sleeping : bool = false

var color_r_value : float = 0.0
var color_g_value : float = 0.0
var color_b_value : float = 0.0
var color_variation_factor : int = 0.1
var color_variation_threshold : int = 0.6



# Called when the node enters the scene tree for the first time.
func _ready():
    blobMeshInstance = find_node("blobMeshInstance", true)
    assert(null != blobMeshInstance)
    
    current_color_index = floor(rand_range(0.0, 3.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if not color_variation_factor + color_r_value + color_g_value + color_b_value > color_variation_threshold:
        color_r_value += color_variation_factor
    else :
        color_r_value = 0.0
        
    var material_blob = blobMeshInstance.get_surface_material(0) as ShaderMaterial
    var new_color = Color(color_r_value, color_g_value, color_b_value)
    material_blob.set_shader_param("emission_color", new_color)
