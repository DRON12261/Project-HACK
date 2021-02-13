extends Node2D

var wave_complete = false
var wave_pause = false
var wave = 0
var enemy_count : int = -1
var no_shop = false

var wave_enemy_damage_mp = 1.0
var wave_enemy_speed_mp = 1.0
var wave_enemy_health_mp = 1.0
var wave_enemy_money_mp = 1.0
var wave_enemy_count_mp = 1.0

var player_enemy_money_mp = 1.0
var player_enemy_heal_mp = 1.0

var mod_enemy_damage_mp = 1.0
var mod_enemy_speed_mp = 1.0
var mod_enemy_health_mp = 1.0
var mod_enemy_count_mp = 1.0
var mod_enemy_money_mp = 1.0

var wave_modificators = ["WAVE_MOD_EMPTY", "WAVE_MOD_1", "WAVE_MOD_2", "WAVE_MOD_3", "WAVE_MOD_4", "WAVE_MOD_5", "WAVE_MOD_6", "WAVE_MOD_7"]
var current_wave_mode = 0

onready var global = get_node("/root/GlobalScene")

export var hit_effect : PackedScene
export var bike_kamikaze : PackedScene
export var shock_sphere : PackedScene
export var laser_sphere : PackedScene
export var mine_spreader : PackedScene

export var map_ost : AudioStream
export var enemy_spawn : int
export var mines_limit : int

var MAX_SPHERES = 10
var MAX_BIKES = 10
var MAX_LASERS = 3
var MAX_SPREADERS = 2

func _ready():
	if global.OST_Player.stream != map_ost:
		global.OST_Player.stream = map_ost
		global.OST_Player.play()
	#while $ShockSpheres.get_child_count() < MAX_SPHERES and $BikeKamikazes.get_child_count() < MAX_BIKES:
	#	spawn_enemies()
	VisualServer.set_default_clear_color(Color("#06111f"))
	global.is_main_menu = false
	global.is_pause = false
	wave_pause = true
	$WavePause.start()

func _process(delta):
	if global.is_pause:
		$SpawnTimer.paused = true
		$WavePause.paused = true
		return
	else:
		$SpawnTimer.paused = false
		$WavePause.paused = false
	
	if enemy_count == 0 and $ShockSpheres.get_child_count() == 0 and $BikeKamikazes.get_child_count() == 0 and $LaserSpheres.get_child_count() == 0 and $MineSpreaders.get_child_count() == 0 and !wave_complete:
		$Player.end_wave()
		wave_complete = true
		mod_enemy_damage_mp = 1.0
		mod_enemy_health_mp = 1.0
		mod_enemy_speed_mp = 1.0
		mod_enemy_count_mp = 1.0
		mod_enemy_money_mp = 1.0
		global.moving_object_speed_mp = 1.0
		$CanvasModulate.color = Color("#404755")

func _physics_process(delta):
	if global.is_pause:
		return

func _unhandled_input(event):
	if event.is_action_pressed("StartWave"):
		if wave_pause and enemy_count <= 0:
			_on_WavePause_timeout()
			$WavePause.stop()

func _generate_hit_effect(hit_position: Vector2)->void:
	var temp = hit_effect.instance()
	add_child(temp)
	temp.position = hit_position

func _on_Player_fired_shot(hit_position: Vector2):
	_generate_hit_effect(hit_position)

func _on_SpawnTimer_timeout():
	if not wave_pause:
		if enemy_count > 0:
			spawn_enemies()

func get_random_position():
	return $SpawnPoints.get_child(int(rand_range(0, $SpawnPoints.get_child_count())))

func spawn_enemies():
	var total_speed_mp = wave_enemy_speed_mp * mod_enemy_speed_mp * global.difficult_mp
	if total_speed_mp > 1.6 and global.difficult_mp < 1.5:
		total_speed_mp = 1.6
	if total_speed_mp > 2 and global.difficult_mp >= 1.5:
		total_speed_mp = 2
	if total_speed_mp < 0.8 and global.difficult_mp > 0.8:
		total_speed_mp = 0.8
	if total_speed_mp < 0.6 and global.difficult_mp <= 0.8:
		total_speed_mp = 0.6
	var enemy_type = int(rand_range(0,4))
	match (enemy_type):
		0:
			if ($ShockSpheres.get_child_count() < MAX_SPHERES):
				var cur_position : Position2D = get_random_position()
				var position_collider : Area2D = cur_position.get_child(0)
				if position_collider.get_overlapping_bodies().size() <= 0:
					var sphere = shock_sphere.instance()
					var sphere_body = sphere.get_node("ShockSphere")
					sphere_body.MAX_HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					sphere_body.HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					sphere_body.SPEED *= total_speed_mp
					sphere_body.DAMAGE *= wave_enemy_damage_mp * mod_enemy_damage_mp * global.difficult_mp
					sphere_body.MONEY *= player_enemy_money_mp * mod_enemy_money_mp * wave_enemy_money_mp
					sphere_body.SCORE *= (wave_enemy_damage_mp + wave_enemy_health_mp + wave_enemy_speed_mp)/3 * (mod_enemy_damage_mp + mod_enemy_health_mp + mod_enemy_speed_mp)/3 * mod_enemy_money_mp * global.difficult_mp
					sphere_body.HEAL *= player_enemy_heal_mp * global.difficult_mp
					sphere_body.set_speed_timer(wave_enemy_speed_mp * mod_enemy_speed_mp * global.difficult_mp)
					sphere.global_position = cur_position.global_position
					$ShockSpheres.add_child(sphere)
					enemy_count -= 1
		1:
			if ($BikeKamikazes.get_child_count() < MAX_BIKES):
				var cur_position : Position2D = get_random_position()
				var position_collider : Area2D = cur_position.get_child(0)
				if position_collider.get_overlapping_bodies().size() <= 0:
					var bike = bike_kamikaze.instance()
					var bike_body = bike.get_node("BikeKamikaze")
					bike_body.MAX_HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					bike_body.HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					bike_body.SPEED *= total_speed_mp
					bike_body.DAMAGE *= wave_enemy_damage_mp * mod_enemy_damage_mp * global.difficult_mp
					bike_body.MONEY *= player_enemy_money_mp * mod_enemy_money_mp * wave_enemy_money_mp
					bike_body.SCORE *= (wave_enemy_damage_mp + wave_enemy_health_mp + wave_enemy_speed_mp)/3 * (mod_enemy_damage_mp + mod_enemy_health_mp + mod_enemy_speed_mp)/3 * mod_enemy_money_mp * global.difficult_mp
					bike_body.HEAL *= player_enemy_heal_mp * global.difficult_mp
					bike.global_position = cur_position.global_position
					$BikeKamikazes.add_child(bike)
					enemy_count -= 1
		2:
			if ($LaserSpheres.get_child_count() < MAX_LASERS):
				var cur_position : Position2D = get_random_position()
				var position_collider : Area2D = cur_position.get_child(0)
				if position_collider.get_overlapping_bodies().size() <= 0:
					var laser = laser_sphere.instance()
					var laser_body = laser.get_node("LaserSphere")
					laser_body.MAX_HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					laser_body.HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					laser_body.SPEED *= total_speed_mp
					laser_body.DAMAGE *= wave_enemy_damage_mp * mod_enemy_damage_mp * global.difficult_mp
					laser_body.MONEY *= player_enemy_money_mp * mod_enemy_money_mp * wave_enemy_money_mp
					laser_body.SCORE *= (wave_enemy_damage_mp + wave_enemy_health_mp + wave_enemy_speed_mp)/3 * (mod_enemy_damage_mp + mod_enemy_health_mp + mod_enemy_speed_mp)/3 * mod_enemy_money_mp * global.difficult_mp
					laser_body.HEAL *= player_enemy_heal_mp * global.difficult_mp
					laser_body.set_speed_timer(wave_enemy_speed_mp * mod_enemy_speed_mp * global.difficult_mp)
					laser.global_position = cur_position.global_position
					$LaserSpheres.add_child(laser)
					enemy_count -= 1
		3:
			if ($MineSpreaders.get_child_count() < MAX_SPREADERS):
				var cur_position : Position2D = get_random_position()
				var position_collider : Area2D = cur_position.get_child(0)
				if position_collider.get_overlapping_bodies().size() <= 0:
					var spreader = mine_spreader.instance()
					var spreader_body = spreader.get_node("MineSpreader")
					spreader_body.MAX_HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					spreader_body.HEALTH *= wave_enemy_health_mp * mod_enemy_health_mp * global.difficult_mp
					spreader_body.SPEED *= total_speed_mp
					spreader_body.DAMAGE *= wave_enemy_damage_mp * mod_enemy_damage_mp * global.difficult_mp
					spreader_body.MONEY *= player_enemy_money_mp * mod_enemy_money_mp * wave_enemy_money_mp
					spreader_body.SCORE *= (wave_enemy_damage_mp + wave_enemy_health_mp + wave_enemy_speed_mp)/3 * (mod_enemy_damage_mp + mod_enemy_health_mp + mod_enemy_speed_mp)/3 * mod_enemy_money_mp * global.difficult_mp
					spreader_body.HEAL *= player_enemy_heal_mp * global.difficult_mp
					spreader_body.mine_limit = mines_limit
					spreader.global_position = cur_position.global_position
					$MineSpreaders.add_child(spreader)
					enemy_count -= 1

func _on_WavePause_timeout():
	wave += 1
	current_wave_mode = int(rand_range(0,3))
	if !current_wave_mode == 1:
		current_wave_mode = int(rand_range(1,8))
	else:
		current_wave_mode = 0
	apply_modificator(current_wave_mode)
	enemy_count = int(enemy_spawn * mod_enemy_count_mp * wave_enemy_count_mp)
	$Player.start_wave(wave, wave_modificators[current_wave_mode])
	wave_complete = false
	no_shop = true

func _on_Player_wave_announcer_animation_finished():
	wave_pause = false
	$Player/Player.wave_enemy_count = enemy_count

func _on_Player_wave_complete_animation_finished():
	wave_pause = true
	no_shop = false
	$WavePause.start()
	wave_enemy_damage_mp += 0.2
	wave_enemy_health_mp += 0.2
	wave_enemy_speed_mp += 0.01
	wave_enemy_money_mp += 0.5
	wave_enemy_count_mp += 0.05

func apply_modificator(mod):
	match(mod):
		0:
			mod_enemy_damage_mp = 1.0
			mod_enemy_health_mp = 1.0
			mod_enemy_speed_mp = 1.0
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
		1:
			mod_enemy_damage_mp = 2.0
			mod_enemy_health_mp = 1.0
			mod_enemy_speed_mp = 0.7
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
		2:
			mod_enemy_damage_mp = 0.5
			mod_enemy_health_mp = 1.0
			mod_enemy_speed_mp = 1.5
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
		3:
			mod_enemy_damage_mp = 0.75
			mod_enemy_health_mp = 2.0
			mod_enemy_speed_mp = 0.75
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
		4:
			mod_enemy_damage_mp = 1.0
			mod_enemy_health_mp = 1.0
			mod_enemy_speed_mp = 1.0
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#010105")
		5:
			mod_enemy_damage_mp = 1.0
			mod_enemy_health_mp = 1.0
			mod_enemy_speed_mp = 1.0
			mod_enemy_count_mp = 1.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 2.0
			$CanvasModulate.color = Color("#404755")
		6:
			mod_enemy_damage_mp = 0.7
			mod_enemy_health_mp = 0.7
			mod_enemy_speed_mp = 0.9
			mod_enemy_count_mp = 2.0
			mod_enemy_money_mp = 1.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
		7:
			mod_enemy_damage_mp = 1.5
			mod_enemy_health_mp = 1.5
			mod_enemy_speed_mp = 1.1
			mod_enemy_count_mp = 0.8
			mod_enemy_money_mp = 2.0
			global.moving_object_speed_mp = 1.0
			$CanvasModulate.color = Color("#404755")
