extends StaticBody2D

@onready var bullet_spawnPoint = $GunSprite/Marker2D
@onready var gunSprite = $GunSprite
@onready var Bullet = preload("res://Scenes/Bullet/bullet.tscn")
var can_shoot : bool = true
var damage : int = 10
var cooldown : float = 1.0

func shoot():
	var dir = (get_global_mouse_position() - global_position).normalized()
	BulletManager.spawn_bullet(global_position, dir, 900, damage)
	can_shoot = false
	$Cooldown.start()
	
func _process(delta: float) -> void:
	handle_attack()
	
func handle_attack() -> void:
	if Input.is_action_just_pressed("Attack"):
		if can_shoot:
			shoot()
 
func handle_buffs() -> void: #for managing damage or speed buffs
	pass

func _on_cooldown_timeout() -> void:
	can_shoot = true
