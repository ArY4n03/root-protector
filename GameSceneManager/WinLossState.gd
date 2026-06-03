extends State

var winlossMenu:Control
var retrybutton:TextureButton
var exittomain:TextureButton

func Enter()->void:
	print("Entered WinLoss State!")
	winlossMenu = get_parent().find_child("WinLossMenu")
	
	retrybutton = winlossMenu.find_child("Retry");
	exittomain = winlossMenu.find_child("MainMenu")
	
	retrybutton.button_down.connect(LoadMainMenu);
	exittomain.button_down.connect(RetryGame);
	pass

func Exit()->void:
	pass
	
func Update(delta)->void:
	pass
	
func Physics_Update(delta)->void:
	pass

func LoadMainMenu()->void:
	print("WinLoss Menu : return to menu button pressed")
	get_tree().change_scene_to_file("res://Entities/Menus/MainMenu.tscn");
	Transitioned.emit(self,"mainmenustate");
	pass
	
func RetryGame()->void:
	print("WinLoss Menu : retry button pressed")
	get_tree().change_scene_to_file("res://Entities/Level/GameLevel.tscn")
	#Background level loading shit maybe...
	Transitioned.emit(self,"gameplaystate")
	pass
