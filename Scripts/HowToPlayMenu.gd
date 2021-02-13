extends Control

onready var global = get_node("/root/GlobalScene")

var map_ost : AudioStream = load("res://OST/MainMenu.ogg")

func _ready():
	if global.OST_Player.stream != map_ost:
		global.OST_Player.stream = map_ost
		global.OST_Player.play()
	$Menu/ScrollContainer/Label.text = tr("HTP_0") + "\n\n" + tr("HTP_1") + "\n" + tr("HTP_2") + "\n" + tr("HTP_3") + "\n" + tr("HTP_4") + "\n" + tr("HTP_5") + "\n" + tr("HTP_6") + "\n" + tr("HTP_7") + "\n\n" + tr("HTP_8") + "\n\n" + tr("HTP_9") + "\n" + tr("HTP_10") + "\n" + tr("HTP_11") + "\n" + tr("HTP_12") + "\n\n" + tr("HTP_13") + "\n" + tr("HTP_14") + "\n" + tr("HTP_15") + "\n" + tr("HTP_16") + "\n\n" + tr("HTP_17") + "\n\n" + tr("HTP_18") + "\n\n" + tr("HTP_19")
	VisualServer.set_default_clear_color(Color("#262333"))

func _process(delta):
	$Menu/ScrollContainer/Panel.rect_size = $Menu/ScrollContainer/Label.rect_size

func _on_Button_pressed():
	global.MenuPressSound.play()
	if global.is_main_menu:
		get_tree().change_scene("res://Scenes/NewGameMenu.tscn")
	else:
		visible = false

func _on_Button_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/ButtonA.play("BackIn")

func _on_Button_mouse_exited():
	$Menu/ButtonA.play("BackOut")
