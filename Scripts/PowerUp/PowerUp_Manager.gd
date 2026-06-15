extends Node
class_name PowerupManager
enum POWERUP {LIFE,SPEED,DAMAGE}
var player = null
var init_speed = 0
var init_damage = 0
var Health_PowerupScene = preload("res://Scenes/PowerUp/LifePowerup.tscn")


func _ready() -> void:
	assign_player()
	
func assign_player() -> void:
	player = get_tree().current_scene.get_node("Player")


func _process(delta: float) -> void:
	#for debugging purpose
	if Input.is_action_just_pressed("Interact"):
		spawn_powerup(Vector2(0,0),POWERUP.LIFE)
	
func powerup_player(powerup:int) -> void:
	if player:
		if powerup == POWERUP.LIFE:
			player.health += 10 #will change this logic later
		elif powerup == POWERUP.SPEED:
			init_speed = player.max_speed
			player.max_speed += 50
			$speed_timer.start()
		elif powerup == POWERUP.DAMAGE:
			init_damage = player.damage
			player.damage += 90
			$damage_timer.start()


func spawn_powerup(pos: Vector2, type: int) -> void:
	var visual = null
	if type == POWERUP.LIFE:
		visual = Health_PowerupScene.instantiate()
	else:
		visual = Health_PowerupScene.instantiate()
	
	if visual != null:		
		visual.global_position = pos
		add_child(visual)
	
func reset_speed() -> void:
	player.max_speed = init_speed

func reset_damage() -> void:
	player.damage = init_damage
