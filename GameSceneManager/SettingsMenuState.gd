extends State

var SettingsMenu:Control
var backbutton:TextureButton

var first_time_setup:bool = false

func Enter()->void:
	print("Entered Settings State!")
	var sm:GameStateMachine = get_parent() as GameStateMachine
	print("Prev StateMachine state : ",sm.prev_state)
	
	self.SettingsMenu = sm.SettingsMenu
	SettingsMenu.visible = true
	HideOtherUIs()
	backbutton = SettingsMenu.find_child("Return") as TextureButton;
	
	if first_time_setup:return
	first_time_setup = true;
	backbutton.button_down.connect(Return)
	pass

func Exit()->void:
	var sm:GameStateMachine = get_parent() as GameStateMachine
	sm.SettingsMenu.hide()
	pass
	
func Update(delta)->void:
	pass
	
func Physics_Update(delta)->void:
	pass

func Return()->void:
	var stateMachine:GameStateMachine = get_parent();
	#print("Settings Menu : Return button pressed!!")
	#print("PrevState : ",stateMachine.prev_state)
	if(stateMachine.prev_state == "MainMenu" || stateMachine.prev_state == "MainMenuState"):
		Transitioned.emit(self,"mainmenustate")
	if(stateMachine.prev_state == "PauseMenu" || stateMachine.prev_state == "PauseMenuState" || stateMachine.prev_state == "PauseState"):
		Transitioned.emit(self,"pausestate")
	pass

func HideOtherUIs()->void:
	var sm:GameStateMachine = get_parent() as GameStateMachine
	sm.MainMenu.hide()
	sm.PauseMenu.hide()
	#sm.SettingsMenu.hide()
	sm.WinlossMenu.hide()
	sm.PowerupMenu.hide()
	pass
