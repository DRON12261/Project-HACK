extends CanvasLayer

var zoom = 3 setget set_zoom

onready var minimap = get_node("HUD/Minimap/MinimapFrame/MarginContainer")
onready var player_icon = get_node("HUD/Minimap/MinimapFrame/MarginContainer/Player")
onready var enemy_icon = get_node("HUD/Minimap/MinimapFrame/MarginContainer/Enemy")
onready var enemy_spawn_icon = get_node("HUD/Minimap/MinimapFrame/MarginContainer/EnemySpawn")
onready var bonus_icon = get_node("HUD/Minimap/MinimapFrame/MarginContainer/Bonus")
onready var player = get_parent()

onready var icons = {"player": player_icon, "enemy": enemy_icon, "enemy_spawn": enemy_spawn_icon, "bonus": bonus_icon}

var grid_scale
var markers = {}
var markers_pos = {}

func _ready():
	$HUD/TipsContainerA.play("TipsFades")

func _process(delta):
	if Input.is_action_just_pressed("map_scale_up"):
		zoom += 0.5
	if Input.is_action_just_pressed("map_scale_down"):
		zoom -= 0.5
	markers = {}
	var all_markers = minimap.get_node("Markers").get_child_count()
	for i in all_markers:
		 minimap.get_node("Markers").get_child(i).queue_free()
	grid_scale = minimap.rect_size / (get_viewport().get_visible_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap")
	var obj_pos
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		minimap.get_node("Markers").add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		obj_pos = (item.global_position - player.global_position) * grid_scale + minimap.rect_size / 2
		if minimap.get_rect().has_point(obj_pos + minimap.rect_position):
			markers[item].scale = Vector2(1, 1) * (5/zoom + 1)
		else:
			markers[item].scale = Vector2(0.9, 0.9) * (5/zoom + 1)
		obj_pos.x = clamp(obj_pos.x, 0, minimap.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, minimap.rect_size.y)
		markers[item].position = obj_pos
#	for item in markers:
#		print(obj_pos)
#		if minimap.get_rect().has_point(obj_pos + minimap.rect_position):
#			markers[item].scale = Vector2(1, 1) * (5/zoom)
#		else:
#			markers[item].scale = Vector2(0.75, 0.75) * (5/zoom)
#		obj_pos.x = clamp(obj_pos.x, 0, minimap.rect_size.x)
#		obj_pos.y = clamp(obj_pos.y, 0, minimap.rect_size.y)
#		markers[item].position = obj_pos

func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = minimap.rect_size / (get_viewport().get_visible_rect().size * zoom)
