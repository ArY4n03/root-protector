extends Node
enum POWERUP {LIFE,SPEED,DAMAGE}
var player = null

func assign_player(body:Node2D) -> void:
	player = body

func powerup_player(powerup:int) -> void:
	if player:
		if powerup == POWERUP.LIFE:
			player.health += 10 #will change this logic later
		elif powerup == POWERUP.SPEED:
			pass
		elif powerup == POWERUP.DAMAGE:
			pass
