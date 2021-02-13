extends KinematicBody2D

export var explosion_effect : PackedScene

onready var global = get_node("/root/GlobalScene")

var motion = Vector2.ZERO
var ACCELERATION = 20
var instantiator : Node2D

func _process(delta):
	if global.is_pause:
		return
	
	apply_friction(ACCELERATION * delta / 2)
	
func _physics_process(delta):
	if global.is_pause:
		return
	
	var collision : KinematicCollision2D = move_and_collide(motion)
	if collision:
		motion = motion.bounce(collision.normal)
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func _on_Timer_timeout():
	var bodies = $Area2D.get_overlapping_bodies()
	var mines = $Area2D.get_overlapping_areas()
	for i in bodies:
		if i.has_method("hit"):
			i.hit(instantiator.DAMAGE*3, instantiator)
	for i in mines:
		if i.has_method("hit"):
			i.hit(instantiator.DAMAGE*3, instantiator)
	var explode = explosion_effect.instance()
	explode.scale = Vector2(3,3)
	explode.type = 1
	explode.global_position = global_position - Vector2(5,5)
	get_parent().add_child(explode)
	queue_free()

