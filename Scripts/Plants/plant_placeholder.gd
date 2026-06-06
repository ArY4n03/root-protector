extends Area2D

@export var crops: Array[PackedScene]
@export var cropImg: Array[Texture2D] =[]


var can_plant = false

func _ready() -> void:
	update_sprite()
		
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	handle_input()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			CropPlantingSystem.cur_cropIndex += 1
			if CropPlantingSystem.cur_cropIndex >= crops.size():
				CropPlantingSystem.cur_cropIndex = 0  # wrap around

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CropPlantingSystem.cur_cropIndex -= 1
			if CropPlantingSystem.cur_cropIndex < 0:
				CropPlantingSystem.cur_cropIndex = crops.size() - 1  # wrap around
		
		update_sprite()
			
func check_area() -> bool: #checks if area is avialable to plant the crop or not
	var entities = get_overlapping_areas() + get_overlapping_bodies()
	
	if len(entities) != 0:
		return false
		
	return true

func plant_crop() -> void:
	can_plant = check_area()

func update_sprite() -> void:
	$Sprite2D.texture = cropImg[CropPlantingSystem.cur_cropIndex]
func handle_input():
	if Input.is_action_just_pressed("Attack"):
		if check_area():
			CropPlantingSystem.plant_crop(global_position,crops[CropPlantingSystem.cur_cropIndex])
		queue_free()
