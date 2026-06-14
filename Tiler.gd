extends TileMapLayer

@export var range:int = 100;
@export var props: Array[PackedScene] = []

var container:Node
func _ready():
	container = find_child("Container");
	z_index = -10;#Setting the z index...
	#Filling in the tile set...
	for x in range(-range,range):
		for y in range(-range,range):
			set_cell(
				Vector2i(x, y),
				1,
				Vector2i(0, 0)
			)
	#Setting up props...
	props_setup();

func props_setup()->void:
	for x in range(-range,range):
		for y in range(-range,range):
			var location:Vector2  = map_to_local(Vector2(x,y))
			var spawn_loc:Vector2 = rand_offset(location);
			var prop:Node2D = rand_prop().instantiate() as Node2D
			container.add_child(prop)
			prop.global_position = spawn_loc
			prop.z_index = -5;
	pass

func rand_prop()->PackedScene:
	var x:int = randi_range(0,props.size()-1)
	var prop:PackedScene = props[x];
	return prop


func rand_offset(input: Vector2) -> Vector2:
	var max_radius: float = tile_set.tile_size.x/2
	var random_angle: float = randf_range(0.0, TAU)
	var random_radius: float = randf_range(0.0, max_radius)
	var offset: Vector2 = Vector2.from_angle(random_angle) * random_radius
	return input + offset
