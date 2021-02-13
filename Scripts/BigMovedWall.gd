extends StaticBody2D

var speed = 300

onready var global = get_node("/root/GlobalScene")
onready var path_follow : PathFollow2D = get_parent().get_parent()

func _ready():
	pass

func _process(delta):
	if global.is_pause:
		return
	
	global_rotation_degrees += 900 * delta

func _physics_process(delta):
	if global.is_pause:
		return
	
	move_loop(delta)

func move_loop(delta):
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta * global.moving_object_speed_mp)
