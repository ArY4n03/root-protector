extends Area2D


enum POWERUP {LIFE,SPEED,DAMAGE}
@export var powerup_type: POWERUP

func _on_body_entered(body: Node2D) -> void:
	get_tree().current_scene.get_node("PowerUpManager").powerup_player(powerup_type)
	queue_free()
