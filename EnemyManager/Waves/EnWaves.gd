class_name waves extends Node

var wave_no:int = 0;
var enemy_spawner:Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawner = find_child("Spawner")
	pass # Replace with function body.

func _on_timeout() -> void:
	#call enemy spawner
	enemy_spawner.Spawn(wave_no);
	wave_no += 1;
	#prints("Wave no : ",wave_no)
	pass # Replace with function body.
