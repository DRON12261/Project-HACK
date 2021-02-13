extends Node

var minimap_icon = "player"

signal fired_shot
signal wave_announcer_animation_finished
signal wave_complete_animation_finished

onready var global = get_node("/root/GlobalScene")

func _process(delta):
	$Bars/HealthBar.set_global_position(Vector2($Smoothing2D/Body.global_position.x - 47,$Smoothing2D/Body.global_position.y - 80))
	$Bars/GunCooldownBar.set_global_position(Vector2($Smoothing2D/Body.global_position.x - 34,$Smoothing2D/Body.global_position.y - 85))
	$Bars/AbilityCooldownBar.set_global_position(Vector2($Smoothing2D/Body.global_position.x - 34,$Smoothing2D/Body.global_position.y - 65))

func _on_Player_fired_shot(hit_position: Vector2):
	emit_signal("fired_shot", hit_position)

func _on_WaveAnnouncerCanvas_animation_finished():
	emit_signal("wave_announcer_animation_finished")

func _on_WaveCompleteCanvas_animation_finished():
	emit_signal("wave_complete_animation_finished")
	$Player.tips_labels.visible = true
	$Player.pause_timer.visible = true

func start_wave(wave : int, mod : String):
	$Player.wave = wave
	$Player.wave_announcer_modificator.text = tr(mod)
	$Player.wave_announcer_animation.play("Fade")
	$Player/ShopMenuCanvas/ShopMenu.visible = false
	global.WaveStart.play()

func end_wave():
	$Player.wave_complete_animation.play("Fade")
	global.WaveEnd.play()
	$Player.HEALTH = $Player.MAX_HEALTH
