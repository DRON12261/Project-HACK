extends KinematicBody2D

var minimap_icon = "enemy"

onready var map = get_parent().get_parent().get_parent()
onready var map_navigation : Navigation2D = get_parent().get_parent().get_parent().get_child(2)
onready var sprite : Node2D = get_parent().get_node("Smoothing2D/Sprite")
onready var health_bar : TextureProgress = get_parent().get_node("HealthBar/HealthBar")
onready var left_beam : Sprite = get_parent().get_node("Smoothing2D/LeftBeam")
onready var left_beam_end : Position2D = get_parent().get_node("Smoothing2D/LeftBeam/End")
onready var up_beam : Sprite = get_parent().get_node("Smoothing2D/UpBeam")
onready var up_beam_end : Position2D = get_parent().get_node("Smoothing2D/UpBeam/End")
onready var down_beam : Sprite = get_parent().get_node("Smoothing2D/DownBeam")
onready var down_beam_end : Position2D = get_parent().get_node("Smoothing2D/DownBeam/End")
onready var right_beam : Sprite = get_parent().get_node("Smoothing2D/RightBeam")
onready var right_beam_end : Position2D = get_parent().get_node("Smoothing2D/RightBeam/End")
export var explosion_effect : PackedScene
var berserk = false

var path : PoolVector2Array
var dir = Vector2()
var MAX_HEALTH = 100
var HEALTH = 100
var DAMAGE = 1
var SPEED = 5
var MONEY = 10
var SCORE = 200
var HEAL = 10
var SPEED_TIME = 6
var SPEED_TIME_MP = 1
var is_alive = true
var i = 0
var who = null
var left_laser = false
var up_laser = false
var right_laser = false
var down_laser = false

onready var global = get_node("/root/GlobalScene")
onready var player = get_parent().get_parent().get_parent().get_child(1).get_child(0) #get_tree().root.get_child(0).get_child(1)

func _ready():
	set_lasers()
	path = map_navigation.get_simple_path(global_position, player.global_position)

func _process(delta):
	if global.is_pause:
		return
	
	health_bar.max_value = MAX_HEALTH
	health_bar.value = HEALTH
	
	if not is_alive:
		var explode = explosion_effect.instance()
		get_parent().get_parent().get_parent().add_child(explode)
		explode.global_rotation_degrees = rand_range(0,360)
		explode.global_position = global_position
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
	
	if left_laser:
		if $LeftBeam.is_colliding():
			left_beam_end.global_position = $LeftBeam.get_collision_point()
			left_beam.region_rect.end.x = left_beam_end.position.length()
			var coll = $LeftBeam.get_collider()
			if coll.has_method("hit_player"):
				if $AttackTimer.is_stopped():
					$LeftBeam.get_collider().hit_player(DAMAGE, 0.15)
		else:
			left_beam_end.global_position = $LeftBeam.cast_to
			left_beam.region_rect.end.x = left_beam_end.position.length()/2
	if up_laser:
		if $UpBeam.is_colliding():
			up_beam_end.global_position = $UpBeam.get_collision_point()
			up_beam.region_rect.end.x = up_beam_end.position.length()
			var coll = $UpBeam.get_collider()
			if coll.has_method("hit_player"):
				if $AttackTimer.is_stopped():
					$UpBeam.get_collider().hit_player(DAMAGE, 0.15)
		else:
			up_beam_end.global_position = $UpBeam.cast_to
			up_beam.region_rect.end.x = up_beam_end.position.length()/2
	if down_laser:
		if $DownBeam.is_colliding():
			down_beam_end.global_position = $DownBeam.get_collision_point()
			down_beam.region_rect.end.x = down_beam_end.position.length()
			var coll = $DownBeam.get_collider()
			if coll.has_method("hit_player"):
				if $AttackTimer.is_stopped():
					$DownBeam.get_collider().hit_player(DAMAGE, 0.15)
		else:
			down_beam_end.global_position = $DownBeam.cast_to
			down_beam.region_rect.end.x = down_beam_end.position.length()/2
	if right_laser:
		if $RightBeam.is_colliding():
			right_beam_end.global_position = $RightBeam.get_collision_point()
			right_beam.region_rect.end.x = right_beam_end.position.length()
			var coll = $RightBeam.get_collider()
			if coll.has_method("hit_player"):
				if $AttackTimer.is_stopped():
					$RightBeam.get_collider().hit_player(DAMAGE, 0.15)
		else:
			right_beam_end.global_position = $RightBeam.cast_to
			right_beam.region_rect.end.x = right_beam_end.position.length()/2
	if $AttackTimer.is_stopped():
		$AttackTimer.start()

func _physics_process(delta):
	if global.is_pause:
		return
	
	if !player.is_alive:
		return
	
	if $Timer.is_stopped():
		path = map_navigation.get_simple_path(global_position, player.global_position)
		if map.enemy_count == 0 and map.get_node("ShockSpheres").get_child_count() == 0 and map.get_node("BikeKamikazes").get_child_count() == 0:
			if not berserk:
				SPEED *= 3
				$Timer.wait_time /= 5
				berserk = true
		check_path()
		dir = dir.normalized() * 20
		dir = dir.rotated(deg2rad(rand_range(-30, 30)))
		$Timer.wait_time = rand_range(SPEED_TIME - 1, SPEED_TIME + 1) * SPEED_TIME_MP
		$Timer.start()
	move_and_slide(dir * SPEED)

func hit(damage, _who : Node2D):
	HEALTH -= damage
	if HEALTH <=0:
		self.who = _who
		is_alive = false

func set_speed_timer(mp):
	$Timer.wait_time = SPEED_TIME * mp
	SPEED_TIME_MP = mp

func set_lasers():
	var laser1 = int(rand_range(0,4))
	var laser2 = laser1
	while laser1 == laser2:
		laser2 = int(rand_range(0,4))
	match(laser1):
		0:
			left_laser = true
		1:
			up_laser = true
		2:
			right_laser = true
		3:
			down_laser = true
	match(laser2):
		0:
			left_laser = true
		1:
			up_laser = true
		2:
			right_laser = true
		3:
			down_laser = true
	if left_laser:
		$LeftBeam.enabled = true
		left_beam.visible = true
	if right_laser:
		$RightBeam.enabled = true
		right_beam.visible = true
	if down_laser:
		$DownBeam.enabled = true
		down_beam.visible = true
	if up_laser:
		$UpBeam.enabled = true
		up_beam.visible = true

func check_path():
	i = 0
	if i < path.size() and i >= 0:
		if (global_position.distance_to(path[i]) < 50):
			i += 1
		dir = path[i] - global_position
	else:
		dir = Vector2.ZERO
