extends Node

signal settingsChanged(settings:Dictionary)

const CONFIG_FILE_PATH:String = "user://settings.cfg"

var settings := {}

func _ready():
	var configFile = ConfigFile.new()
	if FileAccess.file_exists(CONFIG_FILE_PATH):
		var err = configFile.load(CONFIG_FILE_PATH)
		if err != OK:
			push_error("Failed to load config File! Error handling not yet implented!")
			get_tree().quit(1)
		if configFile.get_value("controls", "onscreenButtonsEnabled") == null:
			if OS.has_feature("mobile"):
				configFile.set_value("controls", "onscreenButtonsEnabled", true)
			else:
				configFile.set_value("controls", "onscreenButtonsEnabled", false)
				
		elif configFile.get_value("controls", "helperLineEnabled") == null:
			configFile.set_value("controls", "helperLineEnabled", false)
			
	else:
		if OS.has_feature("mobile"):
			configFile.set_value("controls", "onscreenButtonsEnabled", true)
		else:
			configFile.set_value("controls", "onscreenButtonsEnabled", false)
			
		configFile.set_value("controls", "helperLineEnabled", false)
		if configFile.save(CONFIG_FILE_PATH) != OK:
			push_error("Failed to save config File! Error handling not yet implented!")
			get_tree().quit(1)
	
	setupSettings(configFile)

func setupSettings(configFile: ConfigFile):
	settings.onscreenButtonsEnabled = configFile.get_value("controls", "onscreenButtonsEnabled")
	settings.helperLineEnabled = configFile.get_value("controls", "helperLineEnabled")
	emit_signal("settingsChanged", settings)
