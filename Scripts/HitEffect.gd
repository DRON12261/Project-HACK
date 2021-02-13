extends Node2D

onready var global = get_node("/root/GlobalScene")
onready var particle = $ShootEnd

func _ready():
	particle.emitting = true

func _process(delta):
	if global.is_pause:
		return

func _physics_process(delta):
	if global.is_pause:
		return

func _on_Timer_timeout():
	queue_free()
