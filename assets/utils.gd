extends Object
class_name Utils

static func safe_connect(sender: Object, signal_name: String, target: Object, method: String, binds: Array = [], flags: int = 0) -> void:
    var error := sender.connect(signal_name, target, method, binds, flags)
    assert(error == OK)

static func safe_change_scene(tree: SceneTree, path: String) -> void:
    var error := tree.change_scene(path)
    assert(error == OK)

static func safe_change_scene_to(tree: SceneTree, packed_scene: PackedScene) -> void:
    var error := tree.change_scene_to(packed_scene)
    assert(error == OK)

static func safe_reload_current_scene(tree: SceneTree) -> void:
    var error := tree.reload_current_scene()
    assert(error == OK)

static func check(value: bool) -> void:
    assert(value)
    if not value:
        push_error("Check failed!")
