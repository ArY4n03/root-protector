extends Area2D


enum POWERUP {LIFE,SPEED,DAMAGE}
@export var powerup_tpe: POWERUP

func _on_body_entered(body: Node2D) -> void:
	PowerUpManager.powerup_player(powerup_tpe)
	
