extends Area2D


var velocity = Vector2()
var speed = 530
var isplayerbullet = true
var dmg = 8

func _ready() -> void:
	handle_spriteChange()
	

func handle_spriteChange(): #changes sprite according to its owner (enemy/player)
	if isplayerbullet:
		pass
	else:
		pass
		
func start(damage,_pos,_dir) -> void: #will called by owner at the time of spawning
	dmg = damage
	global_position = _pos
	rotation = _dir.angle()
	velocity = _dir * speed
	
func _process(delta: float) -> void:
	position += velocity * delta
	
func free():
	queue_free()
	
func _on_lifetime_timeout() -> void:
	queue_free()
