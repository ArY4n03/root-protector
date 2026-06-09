extends State

func Enter()->void:
	print("Entered GamePlay State!")
	pass

func Exit()->void:
	pass
	
func Update(delta)->void:
	pass
	
func Physics_Update(delta)->void:
	if(Input.is_action_pressed("PauseGame")):
		print("Pause Game pressed!")
		Transitioned.emit(self,"pausestate")
		pass
	
	pass
	
func HideOtherUIs()->void:
	var sm:GameStateMachine = get_parent() as GameStateMachine
	sm.MainMenu.hide()
	sm.PauseMenu.hide()
	sm.SettingsMenu.hide()
	sm.WinlossMenu.hide()
	sm.PowerupMenu.hide()
