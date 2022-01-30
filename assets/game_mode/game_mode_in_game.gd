extends Spatial

class_name GameModeInGame

export(NodePath) var player_start_path
onready var player_start := get_node_or_null(player_start_path) as Spatial

export(NodePath) var end_level_path
onready var end_level := get_node(end_level_path) as EndLevelTrigger

export(PackedScene) var next_scene: PackedScene
export(PackedScene) var player_class: PackedScene
export(PackedScene) var hud_class: PackedScene
export(PackedScene) var pause_menu_class: PackedScene
export(PackedScene) var death_screen_class: PackedScene

export(float) var override_player_max_life := -1.0
export(float) var override_player_initial_life := -1.0
export(float) var override_player_life_loss_per_seconds := -1.0


onready var persistent_data := get_node("/root/PersistentData") as PersistentData

onready var start_timer := $StartTimer as Timer

var player: Player
var hud: HUD
var pause_menu: PauseMenu
var death_screen: DeathScreen

var active := false
var current_counter_value := 0.0

var musicTimeStamp: float;


func _ready() -> void:
    _spawn_hud()

    assert(start_timer.connect("timeout", self, "_start_level") == OK)
    _spawn_player()
    player.block_inputs = true
    player.player_light.set_invincible(true)
    _register_to_end_level()
    start_timer.start()

func _process(delta: float) -> void:
    if !active:
        return

    _update_time_counter(delta)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_pause_menu") && active:
        _spawn_pause_menu()


func _spawn_hud() -> void:
    hud = hud_class.instance() as HUD
    add_child(hud)


func _spawn_pause_menu() -> void:
    musicTimeStamp = $LevelMusicPlayer.get_playback_position();
    $LevelMusicPlayer.stop();
    pause_menu = pause_menu_class.instance() as PauseMenu
    add_child(pause_menu)
    assert(pause_menu.connect("on_resume", self, "_resume_game") == 0)
    active = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _spawn_death_screen() -> void:
    $LevelMusicPlayer.stop();
    musicTimeStamp = 0.0;
    death_screen = death_screen_class.instance() as DeathScreen
    add_child(death_screen)
    active = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _spawn_player() -> void:
    $LevelMusicPlayer.play();
    player = player_class.instance() as Player
    add_child(player)

    assert(player.player_light.connect("on_die", self, "_on_die") == 0)

    if player_start != null:
        player.set_translation(player_start.get_translation())
        player.set_rotation(player_start.get_rotation())

    if override_player_max_life > 0.0:
        player.player_light.max_life = override_player_max_life

    if override_player_initial_life > 0.0:
        player.player_light.current_life = override_player_initial_life

    if override_player_life_loss_per_seconds > 0.0:
        player.player_light.life_loss_per_second = override_player_life_loss_per_seconds


func _resume_game() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    $LevelMusicPlayer.play(musicTimeStamp);
    active = true


func _register_to_end_level() -> void:
    assert(end_level != null)
    assert(end_level.connect("on_triggered", self, "_on_end_level_triggered") == 0)


func _update_time_counter(delta: float) -> void:
    current_counter_value += delta
    hud.set_counter_value(current_counter_value)


func _on_die() -> void:
    _spawn_death_screen()
    assert(death_screen.connect("on_retry_pressed", self, "_retry_current_level") == 0)


func _on_end_level_triggered() -> void:
    _compute_and_update_total_score()
    _proceed_to_next_scene()


func _compute_and_update_total_score() -> void:
    persistent_data.total_score += 1.0


func _proceed_to_next_scene() -> void:
    if next_scene != null:
        assert(get_tree().change_scene_to(next_scene) == 0)
    else:
        print("No next scene to load !")


func _retry_current_level() -> void:
    assert(get_tree().reload_current_scene() == 0)

func _start_level() -> void:
    hud.set_go()
    active = true
    player.block_inputs = false
    player.player_light.set_invincible(false)
