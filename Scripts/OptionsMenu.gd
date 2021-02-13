extends Control

onready var global = get_node("/root/GlobalScene")

var map_ost : AudioStream = load("res://OST/MainMenu.ogg")

func _ready():
	if global.is_main_menu:
		if global.OST_Player.stream != map_ost:
			global.OST_Player.stream = map_ost
			global.OST_Player.play()
	$Menu/Buttons/LangSelect/OptionButton.add_item(tr("LANG_RU"),0)
	$Menu/Buttons/LangSelect/OptionButton.add_item(tr("LANG_EN"),1)
	if TranslationServer.get_locale() == "ru":
		$Menu/Buttons/LangSelect/OptionButton.selected = 0
	else:
		$Menu/Buttons/LangSelect/OptionButton.selected = 1
	$Menu/Buttons/SFXVolume/SFXSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$Menu/Buttons/OSTVolume/OSTSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST"))
	$Menu/Buttons/FullscreenCheckbox/CheckBox.pressed = OS.window_fullscreen
	VisualServer.set_default_clear_color(Color("#262333"))

func _on_Back_pressed():
	global.MenuPressSound.play()
	if global.is_main_menu:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		visible = false

func _on_CheckBox_toggled(button_pressed):
	global.MenuPressSound.play()
	OS.window_fullscreen = button_pressed
	global.save_config()

func _on_OptionButton_item_selected(index):
	global.MenuPressSound.play()
	match(index):
		0:
			TranslationServer.set_locale("ru")
		1:
			TranslationServer.set_locale("en")
	global.save_config()

func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	global.save_config()

func _on_OSTSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), value)
	global.save_config()

func _on_Back_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/BackA.play("BackIn")

func _on_Back_mouse_exited():
	$Menu/BackA.play("BackOut")
