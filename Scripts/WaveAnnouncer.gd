extends CanvasLayer

signal animation_started
signal animation_finished

func _on_WaveAnnouncerA_animation_finished(anim_name):
	emit_signal("animation_finished")

func _on_WaveAnnouncerA_animation_started(anim_name):
	emit_signal("animation_started")
