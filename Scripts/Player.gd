extends KinematicBody2D

signal fired_shot

var DEF_MAX_SPEED = 500
var MAX_SPEED = 500
var DEF_ACCELERATION = 1000
var ACCELERATION = 1000
var motion = Vector2()

var is_alive = true

var DEF_MAX_HEALTH = 100
var MAX_HEALTH = 100
var HEALTH : int = 100
var SCORE : int = 0
var DEF_DAMAGE = 60
var DAMAGE = 60
var MONEY : int = 0
var weapon_ID = 0
var ability_ID = 0

var burst_count = 0

var time : int = 0
var wave = 0

var health_up_mp = 1.0
var health_tier = 1
var speed_up_mp = 1.0
var speed_tier = 1
var damage_up_mp = 1.0
var damage_tier = 1
var money_up_mp = 1.0
var money_tier = 1
var heal_up_mp = 1.0
var heal_tier = 1

var TOTAL_MONEY : int = 0
var CURRENT_WAVE = 0
var TOTAL_KILLS = 0

var is_right_key = false
var is_left_key = false
var is_up_key = false
var is_down_key = false

var wave_enemy_count = 0

var death_screen_tips = ["DEATH_SCREEN_TIP_0","DEATH_SCREEN_TIP_1","DEATH_SCREEN_TIP_2","DEATH_SCREEN_TIP_3","DEATH_SCREEN_TIP_4","DEATH_SCREEN_TIP_5","DEATH_SCREEN_TIP_6","DEATH_SCREEN_TIP_7","DEATH_SCREEN_TIP_8","DEATH_SCREEN_TIP_9","DEATH_SCREEN_TIP_10","DEATH_SCREEN_TIP_11","DEATH_SCREEN_TIP_12","DEATH_SCREEN_TIP_13","DEATH_SCREEN_TIP_14"]

export var grenade : PackedScene

onready var global = get_node("/root/GlobalScene")
onready var map = get_parent().get_parent()
onready var dash_trail = get_parent().get_node("Smoothing2D/Body/Trail2D")
onready var single_shoot_ray = get_node("Pivot/SingleShootRay")
onready var burst_shoot_ray = get_node("Pivot/BurstShootRay")
onready var shotgun_shoot_rays = get_node("Pivot/ShootgunShootRays")
onready var shoot_sound = get_node("Pivot/AudioStreamPlayer2D")
onready var shoot_light_timer = get_node("Pivot/Timer")
onready var shoot_light = get_node("Pivot/Light2D")
onready var shield : Sprite = get_parent().get_node("Smoothing2D/Shield")
onready var health_label : Label = get_node("HUDCanvas/HUD/LeftUpContainer/Health/CurHealth")
onready var max_health_label : Label = get_node("HUDCanvas/HUD/LeftUpContainer/Health/MaxHealth")
onready var health_bar : TextureProgress = get_node("HUDCanvas/HUD/LeftUpContainer/Health/HealthBar")
onready var score_label : Label = get_node("HUDCanvas/HUD/RightUpContainer/Score/CurScore")
onready var heal_fade : AnimationPlayer = get_node("HUDCanvas/HUD/HealFadeA")
onready var damage_fade : AnimationPlayer = get_node("HUDCanvas/HUD/DamageFadeA")
onready var money_label : Label = get_node("HUDCanvas/HUD/LeftUpContainer/Money/CurMoney")
onready var money_feedback : AnimationPlayer = get_node("HUDCanvas/HUD/LeftUpContainer/Money/MoneyA")
onready var score_feedback : AnimationPlayer = get_node("HUDCanvas/HUD/RightUpContainer/Score/ScoreA")
onready var time_label : Label = get_node("HUDCanvas/HUD/RightUpContainer/Time/CurTime")
onready var body_sprite : Sprite = get_parent().get_node("Smoothing2D/Body")
onready var health_port_bar : TextureProgress = get_parent().get_node("Bars/HealthBar")
onready var gun_cooldown_port_bar : TextureProgress = get_parent().get_node("Bars/GunCooldownBar")
onready var ability_cooldown_bar : TextureProgress = get_parent().get_node("Bars/AbilityCooldownBar")
onready var canvasModulate = get_parent().get_parent().get_child(0)
onready var camera : Camera2D = get_parent().get_node("Smoothing2D/Camera2D")
onready var legs_sprite : Sprite = get_parent().get_node("Smoothing2D/Legs")
onready var dead_screen = get_node("DeathScreenCanvas/DeathScreen")
onready var dead_screen_score : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/Score/CurScore")
onready var dead_screen_time : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/Counters/TimePanel/Time/CurTime")
onready var dead_screen_waves : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/Counters/WavesPanel/Waves/CurWaves")
onready var dead_screen_kills : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/Counters/KillsPanel/Kills/CurKills")
onready var dead_screen_moneys : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/Counters/MoneysPanel/Moneys/CurMoneys")
onready var dead_screen_tip : Label = get_node("DeathScreenCanvas/DeathScreen/TextureRect/DeadScreenTip")
onready var wave_label : Label = get_node("HUDCanvas/HUD/DownContainer/Wave/CurWave")
onready var pause_time_label : Label = get_node("HUDCanvas/HUD/DownContainer/PauseTimer/PauseTimer/CurPauseTime")
onready var pause_timer = get_node("HUDCanvas/HUD/DownContainer/PauseTimer/PauseTimer")
onready var tips_labels : Control = get_node("HUDCanvas/HUD/TipsContainer")
onready var tips_label_animation : AnimationPlayer = get_node("HUDCanvas/HUD/TipsContainerA")
onready var wave_announcer_current_wave : Label = get_node("WaveAnnouncerCanvas/WaveAnnouncer/Frame/Wave/CurWave")
onready var wave_announcer_modificator : Label = get_node("WaveAnnouncerCanvas/WaveAnnouncer/Frame/ModificatorPanel/CurrentModificator")
onready var wave_complete_current_wave : Label = get_node("WaveCompleteCanvas/WaveComplete/Frame/Wave/CurWave")
onready var wave_announcer_animation : AnimationPlayer = get_node("WaveAnnouncerCanvas/WaveAnnouncerA")
onready var wave_complete_animation : AnimationPlayer = get_node("WaveCompleteCanvas/WaveCompleteA")
onready var ability_label : Label = get_node("HUDCanvas/HUD/LeftUpContainer/Ability/Label")
var enemy_par_map

var last_legs_rotation = atan2(0, 0)
var axis = Vector2.ZERO

func _ready():
	body_sprite.get_node("Light2D").energy = 1 - canvasModulate.color.v
	$ShopMenuCanvas/ShopMenu.visible = false
	body_sprite.region_rect.position = Vector2((weapon_ID+1)*64,0)
	
func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		is_up_key = true
	if event.is_action_released("move_up"):
		is_up_key = false
	if event.is_action_pressed("move_right"):
		is_right_key = true
	if event.is_action_released("move_right"):
		is_right_key = false
	if event.is_action_pressed("move_down"):
		is_down_key = true
	if event.is_action_released("move_down"):
		is_down_key = false
	if event.is_action_pressed("move_left"):
		is_left_key = true
	if event.is_action_released("move_left"):
		is_left_key = false
	if Input.is_action_just_pressed("reloadScene"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel"):
		if $ShopMenuCanvas/ShopMenu.visible:
			$ShopMenuCanvas/ShopMenu.visible = false
		elif $PauseMenuCanvas/PauseMenu.visible:
			$PauseMenuCanvas/PauseMenu.visible = false
			$OptionsMenuCanvas/OptionsMenu.visible = false
			$HowToPlayCanvas/HowToPlayMenu.visible = false
			global.is_pause = false
		else:
			if is_alive:
				$PauseMenuCanvas/PauseMenu.visible = true
				$PauseMenuCanvas/PauseMenu.fix_visible()
				$ShieldCoolDown.paused = true
				$DashCoolDown.paused = true
				$GrenadeCoolDown.paused = true
				$SingleShootCoolDown.paused = true
				$BurstShootCoolDown.paused = true
				$ShotgunShootCoolDown.paused = true
				global.is_pause = true

func _process(delta):
	enemy_par_map = get_parent().get_parent().enemy_spawn * get_parent().get_parent().wave_enemy_count_mp
	if global.is_pause:
		return
	else:
		$ShieldCoolDown.paused = false
		$DashCoolDown.paused = false
		$GrenadeCoolDown.paused = false
		$SingleShootCoolDown.paused = false
		$BurstShootCoolDown.paused = false
		$ShotgunShootCoolDown.paused = false
	
	update_HUD()
	
	shield.global_rotation_degrees = 0
	
	if !is_alive:
		return
	
	if not $ShopMenuCanvas/ShopMenu.visible:
		set_camera_offset()
		set_player_rotation()
		if $DashTimer.is_stopped():
			axis = get_axis()
			if axis == Vector2.ZERO:
				apply_friction(DEF_ACCELERATION * delta / 2)
			else:
				apply_motion(axis * ACCELERATION * delta)
		if motion != Vector2.ZERO:
			legs_sprite.global_rotation = atan2(motion.x, -motion.y)
			last_legs_rotation = legs_sprite.global_rotation
		elif last_legs_rotation != null:
			legs_sprite.global_rotation = last_legs_rotation
		if Input.is_action_pressed("shoot"):
			cast_shoot()
		if Input.is_action_just_pressed("ability"):
			cast_ability()
	
	if shoot_light_timer.is_stopped():
		shoot_light.enabled = false
	
	if Input.is_action_just_pressed("ShopMenu"):
		if !map.no_shop:
			$ShopMenuCanvas/ShopMenu.visible = !$ShopMenuCanvas/ShopMenu.visible
			motion = Vector2.ZERO

func _physics_process(delta):
	if global.is_pause:
		return
	
	if !is_alive:
		return
	
	$CollisionShapeLegs.global_rotation = legs_sprite.global_rotation
	motion = move_and_slide(motion)

func get_axis():
	var axis = Vector2.ZERO
	axis.x = int(is_right_key) - int(is_left_key)
	axis.y = int(is_down_key) - int(is_up_key)
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_motion(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func set_player_rotation():
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	body_sprite.look_at(get_global_mouse_position())
	body_sprite.global_rotation_degrees += 90
	look_at(get_global_mouse_position())
	$Pivot.look_at(get_global_mouse_position())
	$Pivot.global_rotation_degrees += 90

func set_camera_offset():
	camera.offset_h = (get_viewport().get_mouse_position().x - get_viewport_rect().size.x/2) / (get_viewport_rect().size.x + 0.001)
	camera.offset_v = (get_viewport().get_mouse_position().y - get_viewport_rect().size.y/2) / (get_viewport_rect().size.y + 0.001)

func _on_Timer_timeout():
	$Pivot/SingleShootRay/Line2D.visible = false
	$Pivot/BurstShootRay/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray1/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray2/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray3/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray4/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray5/Line2D.visible = false
	$Pivot/ShootgunShootRays/Ray6/Line2D.visible = false

func hit_player(damage, trauma):
	if $ShieldTimer.is_stopped():
		if $DashTimer.is_stopped():
			damage_fade.play("Fade")
			camera.add_trauma(trauma)
			HEALTH -= damage
			if HEALTH <= 0:
				is_alive = false
				$ShopMenuCanvas/ShopMenu.visible = false
				if time - (time/60) * 60 < 10:
					dead_screen_time.text = str(time/60) + ":0" + str(time%60)
				else:
					dead_screen_time.text = str(time/60) + ":" + str(time%60)
				dead_screen_score.text = str(SCORE)
				dead_screen_moneys.text = str(TOTAL_MONEY)
				dead_screen_waves.text = str(CURRENT_WAVE)
				dead_screen_kills.text = str(TOTAL_KILLS)
				dead_screen_tip.text = tr(death_screen_tips[int(rand_range(0,15))])
				dead_screen.visible = true
				$Lose.play()
				update_HUD()
				global.is_pause = true

func _on_LevelTimer_timeout():
	if is_alive:
		time += 1

func cast_ability():
	match(ability_ID):
		0:
			if $ShieldCoolDown.is_stopped():
				shield()
		1:
			if $DashCoolDown.is_stopped():
				dash()
		2:
			if $GrenadeCoolDown.is_stopped():
				grenade()

func shield():
	shield.visible = true
	$Shield.play()
	$ShieldCoolDown.start()
	$ShieldTimer.start()

func dash():
	var dash_vec : Vector2
	var mouse_pos : Vector2 = get_global_mouse_position()
	dash_vec = - global_position + get_global_mouse_position()
	motion = dash_vec.normalized() * ACCELERATION
	dash_trail.visible = true
	$Dash.play()
	$DashCoolDown.start()
	$DashTimer.start()

func grenade():
	var gren = grenade.instance()
	var throw_vec : Vector2 = - global_position + get_global_mouse_position()
	gren.global_position = global_position
	gren.motion = throw_vec.normalized() * gren.ACCELERATION
	gren.instantiator = self
	get_parent().get_parent().add_child(gren)
	$GrenadeCoolDown.start()

func cast_shoot():
	match(weapon_ID):
		0:
			if $SingleShootCoolDown.is_stopped():
				single_shoot()
		1:
			if $BurstShootCoolDown.is_stopped():
				burst_shoot()
		2:
			if $ShotgunShootCoolDown.is_stopped():
				shotgun_shoot()

func single_shoot():
	camera.add_trauma(0.12)
	shoot_sound.pitch_scale = rand_range(0.8, 1)
	shoot_sound.play()
	shoot_light_timer.start()
	shoot_light.enabled = true
	#$Camera2D.add_trauma(0.1)
	$Pivot/SingleShootRay/Line2D.points[1].y = single_shoot_ray.cast_to.y
	if single_shoot_ray.is_colliding():
		$Pivot/SingleShootRay/Line2D.points[1].y = global_position.distance_to(single_shoot_ray.get_collision_point())/2
		#print("gotcha")
		emit_signal("fired_shot", single_shoot_ray.get_collision_point())
		var coll = single_shoot_ray.get_collider()
		if coll != null and coll.has_method("hit"):
			coll.hit(DAMAGE, self)
	$Pivot/SingleShootRay/Line2D.visible = true
	$Pivot/SingleShootRay/Timer.start()
	$SingleShootCoolDown.start()

func burst_shoot():
	burst_count = 5
	$BurstTimer.start()
	$BurstShootCoolDown.start()

func burst_single():
	camera.add_trauma(0.08)
	shoot_sound.pitch_scale = rand_range(0.8, 1)
	shoot_sound.play()
	shoot_light_timer.start()
	shoot_light.enabled = true
	$Pivot/BurstShootRay/Line2D.points[1].y = burst_shoot_ray.cast_to.y
	if burst_shoot_ray.is_colliding():
		$Pivot/BurstShootRay/Line2D.points[1].y = global_position.distance_to(burst_shoot_ray.get_collision_point())/2
		emit_signal("fired_shot", burst_shoot_ray.get_collision_point())
		var coll = burst_shoot_ray.get_collider()
		if coll != null and coll.has_method("hit"):
			coll.hit(DAMAGE*0.5, self)
	$Pivot/BurstShootRay/Line2D.visible = true
	$Pivot/BurstShootRay/Timer.start()

func shotgun_shoot():
	camera.add_trauma(0.16)
	for i in range(6):
		shotgun_single(shotgun_shoot_rays.get_child(i), shotgun_shoot_rays.get_child(i).get_child(1), shotgun_shoot_rays.get_child(i).get_child(0))
	$ShotgunShootCoolDown.start()
	$ShotgunReloadTimer.start()

func shotgun_single(ray : RayCast2D, timer : Timer, line : Line2D):
	ray.rotation_degrees = rand_range(-20,20) + 180
	shoot_sound.pitch_scale = rand_range(0.8, 1)
	shoot_sound.play()
	shoot_light_timer.start()
	shoot_light.enabled = true
	line.points[1].y = ray.cast_to.y
	if ray.is_colliding():
		line.points[1].y = global_position.distance_to(ray.get_collision_point())/2
		emit_signal("fired_shot", ray.get_collision_point())
		var coll = ray.get_collider()
		if coll != null and coll.has_method("hit"):
			coll.hit(DAMAGE*0.7, self)
	line.visible = true
	timer.start()

func _on_BurstTimer_timeout():
	if burst_count > 0:
		burst_shoot_ray.rotation_degrees = rand_range(-2, 2) + 180
		burst_single()
		burst_count -= 1
		$BurstTimer.start()

func _on_ShieldTimer_timeout():
	shield.visible = false

func _on_ShotgunReloadTimer_timeout():
	$ShotgunReload.pitch_scale = rand_range(0.9, 1)
	$ShotgunReload.play()

func _on_DashTimer_timeout():
	dash_trail.visible = false

func _on_WaveAnnouncerCanvas_animation_started():
	tips_labels.visible = false

func update_HUD():
	if MONEY > 99999:
		MONEY = 99999
	if MAX_HEALTH > 99999:
		MAX_HEALTH = 99999
	if SCORE > 9999999:
		SCORE = 9999999
	if time > 60000:
		time = 60000
	if HEALTH < 0: 
		HEALTH = 0
	elif HEALTH > MAX_HEALTH:
		HEALTH = MAX_HEALTH
	health_label.text = str(HEALTH)
#	fps_label.text = " " + tr("FPS") + ": " + str(Performance.get_monitor(Performance.TIME_FPS))#str(Engine.get_frames_per_second())
	score_label.text = str(SCORE)
	max_health_label.text = str(MAX_HEALTH)
	health_bar.max_value = MAX_HEALTH
	health_bar.value = HEALTH
	health_port_bar.max_value = MAX_HEALTH
	health_port_bar.value = HEALTH
	money_label.text = str(MONEY)
	if time - (time/60) * 60 < 10:
		time_label.text = str(time/60) + ":0" + str(time%60)
	else:
		time_label.text = str(time/60) + ":" + str(time%60)
	wave_announcer_current_wave.text = str(wave)
	wave_complete_current_wave.text = str(wave)
	if map.wave_pause:
		pause_time_label.text = str(int(map.get_node("WavePause").time_left))
		pause_time_label.set("custom_colors/font_color", Color.white)
	else:
		pause_time_label.text = str(int(wave_enemy_count))
		pause_time_label.set("custom_colors/font_color", Color.red)
	wave_label.text = str(wave)
	dead_screen_waves.text = str(wave - 1)
	
	match (weapon_ID):
		0:
			gun_cooldown_port_bar.max_value = $SingleShootCoolDown.wait_time*100
			gun_cooldown_port_bar.value = $SingleShootCoolDown.time_left*100
		1:
			gun_cooldown_port_bar.max_value = $BurstShootCoolDown.wait_time*100
			gun_cooldown_port_bar.value = $BurstShootCoolDown.time_left*100
		2:
			gun_cooldown_port_bar.max_value = $ShotgunShootCoolDown.wait_time*100
			gun_cooldown_port_bar.value = $ShotgunShootCoolDown.time_left*100
	
	match (ability_ID):
		0:
			ability_cooldown_bar.max_value = $ShieldCoolDown.wait_time*100
			ability_cooldown_bar.value = $ShieldCoolDown.time_left*100
			ability_label.text = tr("SHIELD_U")
		1:
			ability_cooldown_bar.max_value = $DashCoolDown.wait_time*100
			ability_cooldown_bar.value = $DashCoolDown.time_left*100
			ability_label.text = tr("DASH_U")
		2:
			ability_cooldown_bar.max_value = $GrenadeCoolDown.wait_time*100
			ability_cooldown_bar.value = $GrenadeCoolDown.time_left*100
			ability_label.text = tr("GRENADE_U")
