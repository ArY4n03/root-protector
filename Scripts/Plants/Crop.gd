extends Area2D

@export var powerupTime : int
@export var powerupScene:PackedScene

@onready var parent = find_parent("Main")

enum GrowthState {}
var cur_growth : GrowthState 
var powerup = null

func _ready() -> void:
	$"PowerUp Timer".wait_time = powerupTime

func spawn_powerup():
	powerup = powerupScene.instantiate()
	powerup.global_position = global_position
	parent.get_node("PowerupContainer").add_child(powerup)

func on_watered(): #will be triggerd when player waters it
	pass
	
