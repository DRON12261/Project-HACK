extends CanvasLayer

onready var global = get_node("/root/GlobalScene")

func _on_Restart_pressed():
	global.MenuPressSound.play()
	get_tree().reload_current_scene()

func _on_Restart_mouse_entered():
	global.MenuSelectSound.play()
	$DeathScreen/TextureRect/RestartA.play("RestartIn")

func _on_Restart_mouse_exited():
	$DeathScreen/TextureRect/RestartA.play("RestartOut")

func _on_ToMenu_pressed():
	global.MenuPressSound.play()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ToMenu_mouse_entered():
	global.MenuSelectSound.play()
	$DeathScreen/TextureRect/ToMenuA.play("ToMenuIn")

func _on_ToMenu_mouse_exited():
	$DeathScreen/TextureRect/ToMenuA.play("ToMenuOut")
