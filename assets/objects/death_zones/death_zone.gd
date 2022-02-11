extends Area
class_name DeathZone

func _on_DeathZone_body_entered(body: Node) -> void:
    if body is Player:
        var player := body as Player
        player.player_light.kill()
