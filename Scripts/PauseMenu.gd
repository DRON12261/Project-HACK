extends Control

onready var global = get_node("/root/GlobalScene")

func _ready():
	VisualServer.set_default_clear_color(Color("#262333"))

func fix_visible():
	_on_ResumeGame_mouse_exited()
	_on_SaveGame_mouse_exited()
	_on_Restart_mouse_exited()
	_on_Options_mouse_exited()
	_on_Exit_mouse_exited()
	get_parent().get_parent().get_node("OptionsMenuCanvas/OptionsMenu")._on_Back_mouse_exited()

func _on_ResumeGame_pressed():
	global.MenuPressSound.play()
	visible = false
	global.is_pause = false

func _on_SaveGame_pressed():
	global.MenuPressSound.play()
	get_parent().get_parent().get_node("HowToPlayCanvas/HowToPlayMenu").visible = true

func _on_Restart_pressed():
	global.MenuPressSound.play()
	get_tree().reload_current_scene()
	
func _on_Options_pressed():
	global.MenuPressSound.play()
	get_parent().get_parent().get_node("OptionsMenuCanvas/OptionsMenu").visible = true

func _on_Exit_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ResumeGame_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/ResumeGameA.play("ResumeGameIn")

func _on_ResumeGame_mouse_exited():
	$Menu/Buttons/ResumeGameA.play("ResumeGameOut")

func _on_SaveGame_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/SaveGameA.play("SaveGameIn")

func _on_SaveGame_mouse_exited():
	$Menu/Buttons/SaveGameA.play("SaveGameOut")

func _on_Restart_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/RestartA.play("RestartIn")

func _on_Restart_mouse_exited():
	$Menu/Buttons/RestartA.play("RestartOut")

func _on_Options_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/OptionsA.play("OptionsIn")

func _on_Options_mouse_exited():
	$Menu/Buttons/OptionsA.play("OptionsOut")

func _on_Exit_mouse_entered():
	global.MenuSelectSound.play()
	$Menu/Buttons/ExitA.play("ExitIn")

func _on_Exit_mouse_exited():
	$Menu/Buttons/ExitA.play("ExitOut")
