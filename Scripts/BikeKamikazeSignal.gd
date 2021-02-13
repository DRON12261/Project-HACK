extends Node

func _process(delta):
	$HealthBar/HealthBar.set_global_position(Vector2($Smoothing2D/Render.global_position.x - 47,$Smoothing2D/Render.global_position.y - 50))
