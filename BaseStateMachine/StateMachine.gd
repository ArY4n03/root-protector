class_name StateMachine extends Node

@export var initial_state:State

var current_state:State
var previous_state:State #for pushdown automaton
var states:Dictionary[StringName,State] ={}

func _ready() -> void:
	initial_state = get_child(0) as State# GGGGGGGG DANGER GGGGGGGGGGGG !!!
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child #appending children[state names as key and state as value] into the dictionary...
			child.Transitioned.connect(on_state_transition)
			#print(child.name.to_lower())
	if initial_state:
		initial_state.Enter()
		current_state=initial_state

func _process(delta:float):
	if current_state:
		current_state.Update(delta)
	#if previous_state:
		#print(previous_state.name)
		pass
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
		
func on_state_transition(state:State,new_state_name:StringName):
	if state != current_state:
		return 
	var new_state:State= states.get(new_state_name.to_lower())#get(key) returns a pair GG
	if !new_state:
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state=new_state
