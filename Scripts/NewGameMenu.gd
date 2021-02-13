extends Control

onready var global = get_node("/root/GlobalScene")

var map_ost : AudioStream = load("res://OST/MainMenu.ogg")

var maps = ["Nightmare Complex", "Get Psyched", "Quake Done Quick"]
var difficulties = ["DIF_1", "DIF_2", "DIF_3", "DIF_4", "DIF_5", "DIF_6"]

func _ready():
	if global.OST_Player.stream != map_ost:
		global.OST_Player.stream = map_ost
		global.OST_Player.play()
	VisualServer.set_default_clear_color(Color("#262333"))
	global.is_main_menu = true
	global.is_pause = false
	$Menu/SelectBox/Level/OptionButton.add_item(maps[0], 0)
	$Menu/SelectBox/Level/OptionButton.add_item(maps[1], 1)
	$Menu/SelectBox/Level/OptionButton.add_item(maps[2], 2)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[0], 0)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[1], 1)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[2], 2)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[3], 3)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[4], 4)
	$Menu/SelectBox/Difficulty/OptionButton.add_item(difficulties[5], 5)
	$Menu/SelectBox/Level/OptionButton.select(0)
	$Menu/SelectBox/Difficulty/OptionButton.select(2)

func _on_StartGame_pressed():
	global.MenuPressSound.play()
	
	match ($Menu/SelectBox/Difficulty/OptionButton.get_selected_id()):
		0:
			global.difficult_mp = 0.8
		1:
			global.difficult_mp = 0.9
		2:
			global.difficult_mp = 1.0
		3:
			global.difficult_mp = 1.1
		4:
			global.difficult_mp = 1.2
		5:
			global.difficult_mp = 1.5
	
	match ($Menu/SelectBox/Level/OptionButton.get_selected_id()):
		0:
			get_tree().change_scene("res://Maps/NightmareComplex.tscn")
		1:
			get_tree().change_scene("res://Maps/GetPsyched.tscn")
		2:
			get_tree().change_scene("res://Maps/QuakeDoneQuick.tscn")

func _on_StartGame_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/StartGameA.play("StartGameIn")

func _on_StartGame_mouse_exited():
	$Menu/Buttons/StartGameA.play("StartGameOut")

func _on_HowToPlay_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/HowToPlayMenu.tscn")

func _on_HowToPlay_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/HowToPlayA.play("HowToPlayIn")

func _on_HowToPlay_mouse_exited():
	$Menu/Buttons/HowToPlayA.play("HowToPlayOut")

func _on_Back_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_Back_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/BackA.play("BackIn")

func _on_Back_mouse_exited():
	$Menu/Buttons/BackA.play("BackOut")
