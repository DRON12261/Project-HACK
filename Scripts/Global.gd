extends Node2D

onready var OST_Player = get_node("OSTPlayer")
onready var MenuSelectSound = get_node("MenuSelect")
onready var MenuPressSound = get_node("MenuPress")
onready var WaveStart = get_node("WaveStart")
onready var WaveEnd = get_node("WaveEnd")
var is_main_menu = true
var is_pause = false
var moving_object_speed_mp = 1.0

var difficult_mp = 1.0

func _ready():
	load_config()

func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		TranslationServer.set_locale(config.get_value("Settings","Language","ru"))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), config.get_value("Settings","SFXVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), config.get_value("Settings","OSTVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST"))))
		OS.window_fullscreen = config.get_value("Settings","Fullscreen",true)
		if !config.has_section_key("Settings","Language"):
			config.set_value("Settings","Language","ru")
		if !config.has_section_key("Settings","SFXVolume"):
			config.set_value("Settings","SFXVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		if !config.has_section_key("Settings","OSTVolume"):
			config.set_value("Settings","OSTVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST")))
		if !config.has_section_key("Settings","Fullscreen"):
			config.set_value("Settings","Fullscreen",true)
	else:
		config = ConfigFile.new()
		config.set_value("Settings","Language","ru")
		config.set_value("Settings","SFXVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		config.set_value("Settings","OSTVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST")))
		config.set_value("Settings","Fullscreen",true)
	config.save("user://settings.cfg")

func save_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		config.set_value("Settings","Language",TranslationServer.get_locale())
		config.set_value("Settings","SFXVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		config.set_value("Settings","OSTVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST")))
		config.set_value("Settings","Fullscreen",OS.window_fullscreen)
	else:
		config = ConfigFile.new()
		config.set_value("Settings","Language","ru")
		config.set_value("Settings","SFXVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		config.set_value("Settings","OSTVolume",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("OST")))
		config.set_value("Settings","Fullscreen",true)
	config.save("user://settings.cfg")
