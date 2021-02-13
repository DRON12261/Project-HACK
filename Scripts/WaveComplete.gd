extends CanvasLayer

signal animation_finished

func _on_WaveCompleteA_animation_finished(anim_name):
	emit_signal("animation_finished")
