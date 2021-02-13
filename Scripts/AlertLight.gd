extends Node2D

export (Color) var color : Color
export (float) var speedRotation = 300

onready var global = get_node("/root/GlobalScene")

func _ready():
	$Light2D.color = color

func _process(delta):
	if global.is_pause:
		return
	
	global_rotation_degrees += speedRotation * delta

func _physics_process(delta):
	if global.is_pause:
		return
