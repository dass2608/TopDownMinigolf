extends Node

signal settingsChanged(settings:Dictionary)

const CONFIG_FILE_PATH:String = "user://settings.cfg"

const CONFIG_SECTION_HELPER_LINE:String = "helperLine"
const CONFIG_SECTION_CONTROLS:String = "controls"

var settings := {}

func _ready():
	var configFile = ConfigFile.new()
	if FileAccess.file_exists(CONFIG_FILE_PATH):
		var queueSave:bool = false
		var err = configFile.load(CONFIG_FILE_PATH)
		if err != OK:
			push_error("Failed to load config File! Error handling not yet implented!")
			get_tree().quit(1)
		if configFile.get_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", null) == null:
			queueSave = true
			if OS.has_feature("mobile"):
				configFile.set_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", true)
			else:
				configFile.set_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", false)
				
		elif configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineEnabled", null) == null:
			configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineEnabled", false)
			queueSave = true
		elif configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineColor", null) == null:
			configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineColor", Color.WHITE)
			queueSave = true
		elif configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineWidth", null) == null:
			configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineWidth", 10)
			queueSave = true
		
		if queueSave:
			configFile.save(CONFIG_FILE_PATH)
		
	else:
		if OS.has_feature("mobile"):
			configFile.set_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", true)
		else:
			configFile.set_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", false)
			
		configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineEnabled", false)
		configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineColor", Color.WHITE)
		configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineWidth", 10)
		if configFile.save(CONFIG_FILE_PATH) != OK:
			push_error("Failed to save config File! Error handling not yet implented!")
			get_tree().quit(1)
	
	setupSettings(configFile)

func setupSettings(configFile: ConfigFile) -> void:
	settings.onscreenButtonsEnabled = configFile.get_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled")
	settings.helperLineEnabled = configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineEnabled")
	settings.helperLineColor = configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineColor")
	settings.helperLineWidth = configFile.get_value(CONFIG_SECTION_HELPER_LINE, "helperLineWidth")
	emit_signal("settingsChanged", settings)

func setSetting(key:String, value:Variant):
	settings[key] = value
	emit_signal("settingsChanged", settings)
	saveSettings()

func getSetting(key:String) -> Variant:
	if not settings.has(key):
		return null
	return settings[key]

func saveSettings() -> void:
	var configFile = ConfigFile.new()
	configFile.set_value(CONFIG_SECTION_CONTROLS, "onscreenButtonsEnabled", settings.onscreenButtonsEnabled)
	configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineEnabled", settings.helperLineEnabled)
	configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineColor", settings.helperLineColor)
	configFile.set_value(CONFIG_SECTION_HELPER_LINE, "helperLineWidth", settings.helperLineWidth)
	configFile.save(CONFIG_FILE_PATH)
