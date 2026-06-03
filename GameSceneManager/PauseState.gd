extends State

var GameOverlay:CanvasLayer
var PauseMenu:Control
var SettingsMenu:Control
var resumebutton:TextureButton
var settingbutton:TextureButton
var exitbutton:TextureButton

var first_time_setup:bool = false

func _ready():
	Enter()

func Enter()->void:
	print("Pause PowerUp State!")
	var sm:GameStateMachine = get_parent() as GameStateMachine
	PauseMenu = sm.PauseMenu
	PauseMenu.visible = true;
	#Reference Setup
	GameOverlay = PauseMenu.get_parent() as CanvasLayer;
	resumebutton = PauseMenu.find_child("Resume") as TextureButton;
	settingbutton = PauseMenu.find_child("Settings") as TextureButton;
	exitbutton = PauseMenu.find_child("Exit") as TextureButton;
	#Signals Setup
	
	if first_time_setup:return
	first_time_setup = true;
	
	resumebutton.button_down.connect(ResumeGame);
	settingbutton.button_down.connect(ShowSettings);
	exitbutton.button_down.connect(ToMainMenu);
	#pausing
	#GameOverlay.get_parent().set_process(false);
	pass

func Exit()->void:
	PauseMenu.hide();
	pass

func ShowSettings()->void:
	print("Pause Menu : Settings button pressed")
	var statemachine:GameStateMachine = get_parent();
	statemachine.prev_state = self.name;
	statemachine.SettingsMenu.visible = true
	PauseMenu.hide()
	Transitioned.emit(self,"settingsmenustate");
	pass
	
func ToMainMenu()->void:
	print("Pause Menu : exit button pressed")
	#get_tree().change_scene_to_file("res://Entities/Menus/MainMenu.tscn");
	Transitioned.emit(self,"mainmenustate");
	
func ResumeGame()->void:
	print("Pause Menu : resume button pressed")
	var statemachine:GameStateMachine = get_parent();
	statemachine.PauseMenu.hide()
	#GameOverlay.get_parent().set_process(true)
	Transitioned.emit(self,"gameplaystate");

func HideOtherUIs()->void:
	var sm:GameStateMachine = get_parent() as GameStateMachine
	sm.MainMenu.hide()
	#sm.PauseMenu.hide()
	sm.SettingsMenu.hide()
	sm.WinlossMenu.hide()
	sm.PowerupMenu.hide()
