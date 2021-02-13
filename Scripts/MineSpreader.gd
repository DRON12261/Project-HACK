extends KinematicBody2D

var minimap_icon = "enemy"

onready var global = get_node("/root/GlobalScene")
onready var timer : Timer = get_node("Timer")
onready var map = get_parent().get_parent().get_parent()
onready var map_navigation : Navigation2D = get_parent().get_parent().get_parent().get_child(2)
onready var player = get_parent().get_parent().get_parent().get_child(1).get_child(0)
onready var waypoints = get_parent().get_parent().get_parent().get_node("Waypoints")
onready var mines = get_parent().get_parent().get_parent().get_node("Mines")
onready var line_path = get_parent().get_node("Smoothing2D/Render/Line2D")
onready var render = get_parent().get_node("Smoothing2D/Render")
onready var health_bar : TextureProgress = get_parent().get_node("HealthBar/HealthBar")
export var explosion_effect : PackedScene
export var mine : PackedScene

var path : PoolVector2Array
var SPEED = 6000
var DAMAGE = 10
var MAX_HEALTH = 30
var HEALTH = 30
var MONEY = 15
var HEAL = 20
var SCORE = 50
var i = 0
var mine_count = 5
var mine_limit = 10
var move_vec : Vector2 = Vector2.ZERO
var move_speed = 0
var is_alive = true
var who = null
var target
var berserk = false

func _ready():
	target = waypoints.get_child(int(rand_range(0, waypoints.get_child_count()))).global_position
	path = map_navigation.get_simple_path(global_position,target)

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
				$RayCast2D.get_collider().hit_player(DAMAGE, 0.2)
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
	if path.size() <= 2 and global_position.distance_to(path[0]) < 10:
		target = waypoints.get_child(int(rand_range(0, waypoints.get_child_count()))).global_position

func _on_Timer_timeout():
	set_physics_process(false)
	if map.enemy_count == 0 and map.get_node("ShockSpheres").get_child_count() == 0 and map.get_node("BikeKamikazes").get_child_count() == 0:
		target = player.global_position
		if not berserk:
			SPEED *= 2
			berserk = true
	if mine_count <= 0 and mines.get_child_count() >= mine_limit:
		target = player.global_position
	path = map_navigation.get_simple_path(global_position, target)
	timer.wait_time = rand_range(0.05, 0.1)
	timer.start()
	set_physics_process(true)

func _on_Mine_timeout():
	if mine_count > 0:
		if mines.get_child_count() < mine_limit:
			var new_mine = mine.instance()
			new_mine.global_position = global_position
			new_mine.DAMAGE = DAMAGE * 4
			mines.add_child(new_mine)
			mine_count -= 1
