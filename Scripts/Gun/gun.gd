extends StaticBody2D

@onready var bullet_spawnPoint = $GunSprite/Marker2D
@onready var gunSprite = $GunSprite
@onready var Bullet = preload("res://Scenes/Bullet/bullet.tscn")
var can_shoot : bool = true
var damage : int = 10
var cooldown : float = 1.0

func _process(delta: float) -> void:
	handle_attack()
	
func handle_attack() -> void:
	if Input.is_action_just_pressed("Attack"):
		if can_shoot:
			shoot()
		
func shoot() -> void:
	can_shoot = false
	var bullet = Bullet.instantiate()
	bullet.start(damage,bullet_spawnPoint.global_position,Vector2(1,0).rotated(gunSprite.global_rotation))
	get_parent().get_parent().add_child(bullet) #hardcoded this for now will fix this later
	$Cooldown.start()
 
func handle_buffs() -> void: #for managing damage or speed buffs
	pass

func _on_cooldown_timeout() -> void:
	can_shoot = true
