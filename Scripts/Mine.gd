extends Area2D

export var explosion_effect : PackedScene

var DAMAGE = 1

func _ready():
	$AnimationPlayer.play("Animation")

func hit(DAMAGE, who):
	var explode = explosion_effect.instance()
	explode.global_position = global_position - Vector2(5,5)
	explode.scale = Vector2(1,1)
	explode.type = 1
	get_parent().add_child(explode)
	queue_free()

func _on_Mine_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		if body.has_method("hit_player"):
			body.hit_player(DAMAGE, 0.4)
			var explode = explosion_effect.instance()
			explode.global_position = global_position - Vector2(5,5)
			explode.scale = Vector2(3,3)
			explode.type = 1
			get_parent().add_child(explode)
			queue_free()
