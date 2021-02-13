extends Control

onready var global = get_node("/root/GlobalScene")

var map_ost : AudioStream = load("res://OST/AboutUs.ogg")

func _ready():
	if global.OST_Player.stream != map_ost:
		global.OST_Player.stream = map_ost
		global.OST_Player.play()
	$Menu/Label.text = tr("ABOUT_1") + "\n" + tr("ABOUT_2") + "\n\n" + tr("ABOUT_3") + "\n" + tr("ABOUT_4") + "\n" + tr("ABOUT_5")
	VisualServer.set_default_clear_color(Color("#262333"))

func _on_Button_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_Button_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/ButtonA.play("BackIn")

func _on_Button_mouse_exited():
	$Menu/ButtonA.play("BackOut")
