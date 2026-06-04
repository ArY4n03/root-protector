extends Area2D

@export var crops: Array[PackedScene]
@export var cropImage: Array[Texture2D] =[]

var cur_crop = 0
var can_plant = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	handle_input()
	
func check_area() -> bool: #checks if area is avialable to plant the crop or not
	var entities = get_overlapping_areas() + get_overlapping_bodies()
	
	if len(entities) != 0:
		return false
		
	return true

func plant_crop() -> void:
	can_plant = check_area()
	
func handle_input():
	if Input.is_action_just_pressed("Attack"):
		if check_area():
			CropPlantingSystem.plant_crop(global_position,crops[cur_crop])
		queue_free()
