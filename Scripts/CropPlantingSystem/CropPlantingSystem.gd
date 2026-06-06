extends Node

@onready var placeholder_scene = preload("res://Scenes/Plants/plant_placeholder.tscn")


var placeholder = null #placeholder to indicate plants position before its planted
var cur_crop = null #current crop that is to be planted

func _process(delta: float) -> void:
	handle_input()

func check_pos() -> bool:
	return true
	
func plant_crop(pos:Vector2,crop:PackedScene) -> void:
	cur_crop = crop.instantiate()
	cur_crop.global_position = pos
	get_tree().current_scene.add_child(cur_crop)
	CropManager.plant(cur_crop.get_instance_id())
	
func spawn_placeholder() -> void:
	placeholder = placeholder_scene.instantiate()
	var player =  get_tree().get_first_node_in_group("player")
	player.add_child(placeholder)
	
func handle_input() -> void:
	if Input.is_action_just_pressed("plant"):
		spawn_placeholder()
		#print("Planting")
	
