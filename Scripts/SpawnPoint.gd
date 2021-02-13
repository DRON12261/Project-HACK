extends Position2D

var is_empty = true

func _on_Area2D_body_entered(body):
	is_empty = false
