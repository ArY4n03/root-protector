class_name State extends Node

signal Transitioned(current_stat:State,next_state_name:StringName)

func Enter()->void:
	pass

func Exit()->void:
	pass
	
func Update(delta)->void:
	pass
	
func Physics_Update(delta)->void:
	pass
