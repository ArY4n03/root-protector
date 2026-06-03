class_name GameStateMachine extends StateMachine

var prev_state:StringName

var main_menu = preload("res://Entities/Menus/MainMenu.tscn")
var settings_menu= preload("res://Entities/Menus/SettingsMenu.tscn")
var pause_menu= preload("res://Entities/Menus/PauseMenu.tscn")
var powerup_menu= preload("res://Entities/Menus/PowerUpMenu.tscn")
var winloss_menu = preload("res://Entities/Menus/WinLossMenu.tscn")


var MainMenu:Control
var SettingsMenu:Control
var PauseMenu:Control
var PowerupMenu:Control
var WinlossMenu:Control

func _ready() -> void:
	setup_state_scenes()
	setup_states_nodes()
	super._ready()
	#making it a singleton...
	

func _process(delta:float):
	super._process(delta)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func on_state_transition(state:State,new_state_name:StringName):
	super.on_state_transition(state,new_state_name)

func setup_states_nodes()->void:
	var n:Node 
	n = Node.new()
	add_child(n)
	n.name = "MainMenuState"
	n.set_script(load("res://Entities/GameSceneManager/MainMenuState.gd"))
	n = Node.new()
	add_child(n)
	n.name = "SettingsMenuState"
	n.set_script(load("res://Entities/GameSceneManager/SettingsMenuState.gd"))
	n = Node.new()
	add_child(n)
	n.name = "GamePlayState"
	n.set_script(load("res://Entities/GameSceneManager/GamePlayState.gd"))
	n = Node.new()
	add_child(n)
	n.name = "PauseState"
	n.set_script(load("res://Entities/GameSceneManager/PauseState.gd"))
	n = Node.new()
	add_child(n)
	n.name = "PowerUpState"
	n.set_script(load("res://Entities/GameSceneManager/PowerUpState.gd"))
	n = Node.new()
	add_child(n)
	n.name = "WinLossState"
	n.set_script(load("res://Entities/GameSceneManager/WinLossState.gd"))
	pass
func setup_state_scenes()->void:
	#print("Setting up UI scenes")
	var e
	e = main_menu.instantiate()
	add_child(e)
	e.name = "MainMenu"
	MainMenu = e
	e = settings_menu.instantiate()
	add_child(e)
	e.name = "SettingsMenu"
	SettingsMenu = e
	e = pause_menu.instantiate()
	add_child(e)
	e.name = "PauseMenu"
	PauseMenu = e
	e = powerup_menu.instantiate()
	add_child(e)
	e.name = "PowerUpMenu"
	PowerupMenu = e
	e = winloss_menu.instantiate()
	add_child(e)
	e.name = "WinLossMenu"
	WinlossMenu = e
	pass
