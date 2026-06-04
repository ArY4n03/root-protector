extends State

var MainMenu:Control#self
var startbutton:TextureButton
var settingbutton:TextureButton
var exitbutton:TextureButton

var first_time_setup:bool = false

func _ready():
	#Enter()
	pass


func Enter()->void:
	print("Entered MainMenu State!")
	var sm:GameStateMachine = get_parent() as GameStateMachine
	self.MainMenu = sm.MainMenu
	MainMenu.visible = true;
	HideOtherUIs()
	if !MainMenu:return
	print("MainMenu Node Name : ",MainMenu.name)
	
	#print("main menu started")
	#get_tree().change_scene_to_file("res://Entities/Menus/MainMenu.tscn")
	#Reference Setup
	startbutton = MainMenu.find_child("StartGame") as TextureButton;
	settingbutton = MainMenu.find_child("Settings") as TextureButton;
	exitbutton = MainMenu.find_child("ExitGame") as TextureButton;
	#Signals Setup
	if first_time_setup:return
	first_time_setup = true;
	
	startbutton.button_down.connect(LoadGameLevel);
	settingbutton.button_down.connect(ShowSettings);
	exitbutton.button_down.connect(ExitGame);
	pass

func Exit()->void:
	pass

func LoadGameLevel()->void:
	print("MainMenu : Start button pressed!")
	MainMenu.hide()
	#get_tree().change_scene_to_file("res://Entities/Level/GameLevel.tscn")
	#Background level loading shit maybe...
	Transitioned.emit(self,"gameplaystate")
	pass
	
func ShowSettings()->void:
	print("MainMenu : Settings button pressed!")
	var statemachine:GameStateMachine = get_parent();
	statemachine.prev_state = self.name;
	#Hide this menu and show settings menu OR show on top of start menu...
	Transitioned.emit(self,"settingsmenustate");
	pass
	
func ExitGame()->void:
	print("MainMenu : Exit button pressed!")
	get_tree().quit()
	pass

func HideOtherUIs()->void:
	var sm:GameStateMachine = get_parent() as GameStateMachine
	sm.PauseMenu.hide()
	sm.SettingsMenu.hide()
	sm.WinlossMenu.hide()
	sm.PowerupMenu.hide()
	pass
