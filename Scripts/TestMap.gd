extends Node2D

export var hit_effect: PackedScene

func _generate_hit_effect(hit_position: Vector2)->void:
	var temp = hit_effect.instance()
	add_child(temp)
	temp.position = hit_position


func _on_Player_fired_shot(hit_position: Vector2):
	_generate_hit_effect(hit_position)


func _on_Timer_timeout():
	$StartOperationVoice/AudioStreamPlayer.play()
