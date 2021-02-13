extends KinematicBody2D

var minimap_icon = "enemy"

onready var raycast : RayCast2D = get_node("RayCast2D")
onready var sprite : Node2D = get_parent().get_node("Smoothing2D/Sprite")
onready var health_bar : TextureProgress = get_parent().get_node("HealthBar/HealthBar")
onready var map_navigation : Navigation2D = get_parent().get_parent().get_parent().get_child(2)
export var explosion_effect : PackedScene

var path : PoolVector2Array
var dir = Vector2()
var MAX_HEALTH = 50
var HEALTH = 50
var DAMAGE = 10
var SPEED = 30
var MONEY = 10
var SCORE = 200
var HEAL = 10
var SPEED_TIME = 2
var is_alive = true
var who = null
var i = 0

onready var global = get_node("/root/GlobalScene")
onready var player = get_parent().get_parent().get_parent().get_child(1).get_child(0) #get_tree().root.get_child(0).get_child(1)

func _ready():
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
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.has_method("hit_player"):
			if $AttackTimer.is_stopped():
				raycast.get_collider().hit_player(DAMAGE, 0.2)
				$AttackTimer.start()

func _physics_process(delta):
	if global.is_pause:
		return
	
	if !player.is_alive:
		return
	
	if $Timer.is_stopped():
		path = map_navigation.get_simple_path(global_position, player.global_position)
		check_path()
		dir = dir.normalized() * 20
		dir = dir.rotated(deg2rad(rand_range(-30, 30)))
		$Timer.wait_time = rand_range(1, 1.3)
		$Timer.start()
	move_and_slide(dir * SPEED)
	look_at(player.global_position)
	sprite.global_rotation_degrees += 40

func hit(damage, _who : Node2D):
	HEALTH -= damage
	if HEALTH <=0:
		self.who = _who
		is_alive = false

func set_speed_timer(mp):
	$Timer.wait_time = SPEED_TIME * mp

func check_path():
	i = 0
	if i < path.size() and i >= 0:
		if (global_position.distance_to(path[i]) < 50):
			i += 1
		dir = path[i] - global_position
	else:
		dir = Vector2.ZERO
