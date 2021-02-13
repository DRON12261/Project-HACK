extends KinematicBody2D

var minimap_icon = "enemy"

onready var global = get_node("/root/GlobalScene")
onready var timer : Timer = get_node("Timer")
onready var map_navigation : Navigation2D = get_parent().get_parent().get_parent().get_child(2)
onready var player = get_parent().get_parent().get_parent().get_child(1).get_child(0) 
onready var line_path = get_parent().get_node("Smoothing2D/Render/Line2D")
onready var render = get_parent().get_node("Smoothing2D/Render")
onready var health_bar : TextureProgress = get_parent().get_node("HealthBar/HealthBar")
export var explosion_effect : PackedScene

var path : PoolVector2Array
var SPEED = 9000
var DAMAGE = 20
var MAX_HEALTH = 30
var HEALTH = 30
var MONEY = 15
var HEAL = 20
var SCORE = 50
var i = 0
var move_vec : Vector2 = Vector2.ZERO
var move_speed = 0
var is_alive = true
var who = null

func _ready():
	path = map_navigation.get_simple_path(global_position, player.global_position)

func _physics_process(delta):
	if global.is_pause:
		return
	
	if not player.is_alive:
		return
	
	_process(delta)
	move_and_slide(move_vec.normalized() * move_speed)

func _process(delta):
	if global.is_pause:
		return
	
	health_bar.max_value = MAX_HEALTH
	health_bar.value = HEALTH
	
	if not is_alive:
		var explode = explosion_effect.instance()
		explode.global_position = global_position
		explode.global_rotation_degrees = rand_range(0,360)
		get_parent().get_parent().get_parent().add_child(explode)
		if who != null:
			who.heal_fade.play("Fade")
			who.money_feedback.play("Feedback")
			who.score_feedback.play("Feedback")
			who.MONEY += int(MONEY) * player.money_up_mp
			who.SCORE += int(SCORE)
			who.HEALTH += HEAL * player.heal_up_mp
			who.TOTAL_MONEY += MONEY
			who.TOTAL_KILLS += 1
			who.wave_enemy_count -= 1
		get_parent().queue_free()
	
	if not player.is_alive:
		return
	attack()
	move_speed = SPEED * delta
	#render.global_position = global_position
	#render.global_rotation = global_rotation
	check_path()

func hit(damage, _who : Node2D):
	HEALTH -= damage
	if HEALTH <=0:
		is_alive = false
		self.who = _who

func generate_path():
	if timer.is_stopped():
		pass

func attack():
	if $RayCast2D.is_colliding():
		var coll = $RayCast2D.get_collider()
		if coll.has_method("hit_player"):
			if $AttackTimer.is_stopped():
				$RayCast2D.get_collider().hit_player(DAMAGE, 0.4)
				$RayCast2D.get_collider().wave_enemy_count -= 1
				var explode = explosion_effect.instance()
				explode.global_position = global_position
				explode.scale = Vector2(3,3)
				explode.type = 1
				explode.global_rotation_degrees = rand_range(0,360)
				get_parent().get_parent().get_parent().add_child(explode)
				get_parent().queue_free()
				$AttackTimer.start()

func check_path():
	line_path.global_position = Vector2.ZERO
	line_path.global_rotation_degrees = 0
	line_path.points = path
	i = 0
	if i < path.size() and i >= 0:
		if (global_position.distance_to(path[i]) < 50):
			i += 1
		move_vec = path[i] - global_position
		look_at(path[i])
		global_rotation_degrees += 90
	else:
		move_vec = Vector2.ZERO

func _on_Timer_timeout():
	set_physics_process(false)
	path = map_navigation.get_simple_path(global_position, player.global_position)
	timer.wait_time = rand_range(0.05, 0.1)
	timer.start()
	set_physics_process(true)
