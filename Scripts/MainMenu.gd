extends Control

onready var global = get_node("/root/GlobalScene")

var map_ost : AudioStream = load("res://OST/MainMenu.ogg")

func _ready():
	if global.OST_Player.stream != map_ost:
		global.OST_Player.stream = map_ost
		global.OST_Player.play()
	VisualServer.set_default_clear_color(Color("#262333"))
	global.is_main_menu = true
	global.is_pause = false
	
func _on_StartGame_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/NewGameMenu.tscn")

func _on_Exit_pressed():
	global.MenuPressSound.play()
	get_tree().quit()

func _on_Options_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/OptionsMenu.tscn")

func _on_About_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/AboutMenu.tscn")

func _on_StartGame_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/StartGameA.play("StartGameIn")

func _on_StartGame_mouse_exited():
	$Menu/Buttons/StartGameA.play("StartGameOut")

func _on_Options_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/OptionsA.play("OptionsIn")

func _on_Options_mouse_exited():
	$Menu/Buttons/OptionsA.play("OptionsOut")

func _on_About_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/AboutA.play("AboutIn")

func _on_About_mouse_exited():
	$Menu/Buttons/AboutA.play("AboutOut")

func _on_Exit_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/ExitA.play("ExitIn")

func _on_Exit_mouse_exited():
	$Menu/Buttons/ExitA.play("ExitOut")
