extends CharacterBody2D

@export var damage : int = 10 # for now its export var
@export var max_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1500.0

@onready var Bullet = preload("res://Scenes/Bullet/bullet.tscn")
@onready var Gun = $Gun/GunSprite

var can_attack = true
func _ready() -> void:
	limit_camera()
	
func _physics_process(delta) -> void:
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta) -> void:
	Gun.look_at(get_global_mouse_position())
	var input_dir = handle_input() #retriving input dir
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * max_speed,acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
	

func handle_input() -> Vector2:
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	input_dir = input_dir.normalized()
	
	return input_dir


func limit_camera() -> void: #limits camera
	pass
