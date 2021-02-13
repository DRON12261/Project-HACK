extends CanvasLayer

onready var player = get_parent()
onready var global = get_node("/root/GlobalScene")
var enemy_per_map
onready var damage_up_label : LineEdit = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/DamageUp/LineEdit")
onready var heal_up_label : LineEdit = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/HealUp/LineEdit")
onready var money_up_label : LineEdit = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/MoneyUp/LineEdit")
onready var speed_up_label : LineEdit = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/SpeedUp/LineEdit")
onready var health_up_label : LineEdit = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/HealthUp/LineEdit")
onready var damage_up_button : Button = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/DamageUp/DamageUp")
onready var heal_up_button : Button = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/HealUp/HealUp")
onready var money_up_button : Button = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/MoneyUp/MoneyUp")
onready var speed_up_button : Button = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/SpeedUp/SpeedUp")
onready var health_up_button : Button = get_node("ShopMenu/BackGround/Shop/Upgrade/Upgrades/HealthUp/HealthUp")

var health_plus = 1
var speed_plus = 0.02
var damage_plus = 0.2
var money_plus = 0.05
var heal_plus = 1

func _ready():
	match(player.weapon_ID):
		0:
			$ShopMenu/BackGround/Shop/Ability/Abilities/SingleShoot.pressed = true
		1:
			$ShopMenu/BackGround/Shop/Ability/Abilities/BurstShoot.pressed = true
		2:
			$ShopMenu/BackGround/Shop/Ability/Abilities/ShotgunShoot.pressed = true
	match(player.ability_ID):
		0:
			$ShopMenu/BackGround/Shop/Ability/Abilities/Shield.pressed = true
		1:
			$ShopMenu/BackGround/Shop/Ability/Abilities/Dash.pressed = true
		2:
			$ShopMenu/BackGround/Shop/Ability/Abilities/Grenade.pressed = true

func _process(delta):
	$ShopMenu/BackGround/Tools/CurMoney.text = str(player.MONEY)
	$ShopMenu/BackGround/Shop.set_tab_title(1, tr("UPGRADE"))
	$ShopMenu/BackGround/Shop.set_tab_title(0, tr("ABILITY"))
	enemy_per_map = player.enemy_par_map
	var default_cost = 100 * enemy_per_map/20
	health_up_label.text = str(player.health_up_mp * 100) + " -> " + str((player.health_up_mp+health_plus) * 100)
	health_up_button.text = str(default_cost + int(player.health_tier/2 * default_cost))
	speed_up_label.text = str(player.speed_up_mp) + "% -> " + str(player.speed_up_mp + speed_plus) + "%"
	speed_up_button.text = str(default_cost + int(player.speed_tier/2 * default_cost))
	damage_up_label.text = str(player.DAMAGE) + " -> " + str((player.DAMAGE/player.damage_up_mp) * (player.damage_up_mp + damage_plus))
	damage_up_button.text = str(default_cost + int(player.damage_tier/2 * default_cost))
	money_up_label.text = str(player.money_up_mp) + "% -> " + str(player.money_up_mp + money_plus) + "%"
	money_up_button.text = str(default_cost + int(player.money_tier/2 * default_cost))
	heal_up_label.text = str(player.heal_up_mp) + "% -> " + str(player.heal_up_mp + heal_plus) + "%"
	heal_up_button.text = str(default_cost + int(player.heal_tier/2 * default_cost))
	if int(health_up_button.text) > player.MONEY:
		health_up_button.disabled = true
	else:
		health_up_button.disabled = false
	if int(speed_up_button.text) > player.MONEY:
		speed_up_button.disabled = true
	else:
		speed_up_button.disabled = false
	if int(damage_up_button.text) > player.MONEY:
		damage_up_button.disabled = true
	else:
		damage_up_button.disabled = false
	if int(money_up_button.text) > player.MONEY:
		money_up_button.disabled = true
	else:
		money_up_button.disabled = false
	if int(heal_up_button.text) > player.MONEY:
		heal_up_button.disabled = true
	else:
		heal_up_button.disabled = false

func _on_Exit_pressed():
	global.MenuPressSound.play()
	$ShopMenu.visible = false

func _on_SingleShoot_pressed():
	global.MenuPressSound.play()
	player.weapon_ID = 0
	player.body_sprite.region_rect.position = Vector2((player.weapon_ID+1)*64,0)
	$ShopMenu/BackGround/Shop/Ability/Abilities/SingleShoot.pressed = true
	$ShopMenu/BackGround/Shop/Ability/Abilities/BurstShoot.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/ShotgunShoot.pressed = false

func _on_BurstShoot_pressed():
	global.MenuPressSound.play()
	player.weapon_ID = 1
	player.body_sprite.region_rect.position = Vector2((player.weapon_ID+1)*64,0)
	$ShopMenu/BackGround/Shop/Ability/Abilities/SingleShoot.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/BurstShoot.pressed = true
	$ShopMenu/BackGround/Shop/Ability/Abilities/ShotgunShoot.pressed = false

func _on_ShotgunShoot_pressed():
	global.MenuPressSound.play()
	player.weapon_ID = 2
	player.body_sprite.region_rect.position = Vector2((player.weapon_ID+1)*64,0)
	$ShopMenu/BackGround/Shop/Ability/Abilities/SingleShoot.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/BurstShoot.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/ShotgunShoot.pressed = true

func _on_Shield_pressed():
	global.MenuPressSound.play()
	player.ability_ID = 0
	$ShopMenu/BackGround/Shop/Ability/Abilities/Shield.pressed = true
	$ShopMenu/BackGround/Shop/Ability/Abilities/Dash.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/Grenade.pressed = false

func _on_Dash_pressed():
	global.MenuPressSound.play()
	player.ability_ID = 1
	$ShopMenu/BackGround/Shop/Ability/Abilities/Shield.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/Dash.pressed = true
	$ShopMenu/BackGround/Shop/Ability/Abilities/Grenade.pressed = false

func _on_Grenade_pressed():
	global.MenuPressSound.play()
	player.ability_ID = 2
	$ShopMenu/BackGround/Shop/Ability/Abilities/Shield.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/Dash.pressed = false
	$ShopMenu/BackGround/Shop/Ability/Abilities/Grenade.pressed = true

func _on_SingleShoot_mouse_entered():
	global.MenuSelectSound.play()

func _on_Shield_mouse_entered():
	global.MenuSelectSound.play()

func _on_BurstShoot_mouse_entered():
	global.MenuSelectSound.play()

func _on_Dash_mouse_entered():
	global.MenuSelectSound.play()

func _on_ShotgunShoot_mouse_entered():
	global.MenuSelectSound.play()

func _on_Grenade_mouse_entered():
	global.MenuSelectSound.play()

func _on_Ability_tab_changed(tab):
	global.MenuPressSound.play()

func _on_Exit_mouse_entered():
	global.MenuSelectSound.play()

func _on_Shop_tab_changed(tab):
	global.MenuPressSound.play()

func _on_HealthUp_pressed():
	global.MenuPressSound.play()
	player.health_up_mp += heal_plus
	player.MAX_HEALTH = player.DEF_MAX_HEALTH * player.health_up_mp
	player.HEALTH = player.MAX_HEALTH
	player.MONEY -= int(health_up_button.text)
	player.health_tier += 1

func _on_HealthUp_mouse_entered():
	global.MenuSelectSound.play()

func _on_SpeedUp_pressed():
	global.MenuPressSound.play()
	player.speed_up_mp += speed_plus
	player.ACCELERATION = player.DEF_ACCELERATION * player.speed_up_mp
	player.MAX_SPEED = player.DEF_MAX_SPEED * player.speed_up_mp
	player.MONEY -= int(speed_up_button.text)
	player.speed_tier += 1

func _on_SpeedUp_mouse_entered():
	global.MenuSelectSound.play()

func _on_DamageUp_pressed():
	global.MenuPressSound.play()
	player.damage_up_mp += damage_plus
	player.DAMAGE = player.DEF_DAMAGE * player.damage_up_mp
	player.MONEY -= int(damage_up_button.text)
	player.damage_tier += 1

func _on_DamageUp_mouse_entered():
	global.MenuSelectSound.play()

func _on_MoneyUp_pressed():
	global.MenuPressSound.play()
	player.money_up_mp += money_plus
	player.MONEY -= int(money_up_button.text)
	player.money_tier += 1

func _on_MoneyUp_mouse_entered():
	global.MenuSelectSound.play()

func _on_HealUp_pressed():
	global.MenuPressSound.play()
	player.heal_up_mp += heal_plus
	player.MONEY -= int(heal_up_button.text)
	player.heal_tier += 1

func _on_HealUp_mouse_entered():
	global.MenuSelectSound.play()
