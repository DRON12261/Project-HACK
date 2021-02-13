extends Node2D

onready var type = 0

func _ready():
	match (type):
		0:
			$SmallExplode.pitch_scale = rand_range(0.8, 1)
			$SmallExplode.play()
		1:
			$SmallExplode.pitch_scale = rand_range(0.8, 1)
			$BigExplode.play()
	$AnimationPlayer.play("Light")

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing = false
	$AnimatedSprite.visible = false
	if $SmallExplode.playing or $BigExplode.playing:
		return
	queue_free()
	print("Explode")

func _on_SmallExplode_finished():
	queue_free()

func _on_BigExplode_finished():
	queue_free()
