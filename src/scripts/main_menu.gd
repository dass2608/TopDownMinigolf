extends Node

const gameScene = preload("res://src/scenes/game.tscn")
const levelEditorScene = preload("res://src/scenes/level_editor.tscn")

func getLevelArray() -> Array[String]:
	var files:Array[String] = []
	var dir = DirAccess.open("res://src/scenes/levels")
	if dir:
		dir.list_dir_begin()
		var filename:String = dir.get_next()
		while filename != "":
			if dir.current_is_dir(): continue
			else:
				if filename.begins_with(".") or filename.begins_with("_"): continue
				files.push_back(filename)
			filename = dir.get_next()
#		print(files)
		files.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
#		print(files)
		return files
	else:
		push_error("Unable to read levels!")
		get_tree().quit(1)
		return []


func _ready():
	var levelArray = getLevelArray()
	for i in levelArray:
		var buttonNode = load("res://src/scenes/level_button.tscn").instantiate()
		buttonNode.text = i.split(".", false, 1)[0]
		buttonNode.add_theme_font_size_override(&"font_size", 32)
		buttonNode.flat = true
		buttonNode.connect(&"selected", _levelSelected)
		$MenuItems/PanelLevelselect/ScrollContainer/VBoxContainer.add_child(buttonNode)


func _on_button_play_pressed():
	$MenuItems/PanelLevelselect.show()

func _levelSelected(levelName:String, pathOverride = null):
	var game = gameScene.instantiate()
	game.loadSettings($SettingsManager.settings)
	if pathOverride != null:
		game.loadLevel(levelName, pathOverride)
	else:
		game.loadLevel(levelName)
	game.connect(&"levelCompleted", _levelDone)
	game.levelAborted.connect(_levelAborted)
	game.levelRestarted.connect(_levelRestarted)
	$SettingsManager.settingsChanged.connect(game.loadSettings)
	
	add_child(game, true)
	$MenuItems.hide()
	$MenuItems/PanelLevelselect.hide()

func _levelDone(shots:int, level:String):
	for i in get_children():
		if i.name == "Game":
			i.queue_free()
			$MenuItems.show()
			break
	$MenuItems/MenuButtons/LabelLevelComplete.text = level.trim_suffix(".tscn") + " completed in " + str(shots) + " shots!"

func _levelAborted():
	for i in get_children():
		if i.name == "Game":
			i.queue_free()
			break
	$MenuItems/MenuButtons/LabelLevelComplete.text = "Level aborted!"
	$MenuItems.show()

func _levelRestarted(levelName, pathOverride = null):
	_levelAborted()
	await get_tree().process_frame
	if not pathOverride:
		_levelSelected(levelName)
	else:
		_levelSelected(levelName, pathOverride)

func _on_button_e_net_pressed():
	$MenuItems/Credits/MainScreen.hide()
	$MenuItems/Credits/ENet.show()

func _on_buttonmbed_tls_pressed():
	$MenuItems/Credits/MainScreen.hide()
	$MenuItems/Credits/mbedTLS.show()

func _on_button_about_credits_pressed():
	$MenuItems/Credits.show()

func _on_button_main_screen_back_pressed():
	$MenuItems/Credits.hide()

func _on_button_back_pressed():
	$MenuItems/Credits/ENet.hide()
	$MenuItems/Credits/mbedTLS.hide()
	$MenuItems/Credits/MainScreen.show()


func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	$MenuItems/SettingsMenu.show()

func _on_button_play_custom_pressed():
	var fileDial:FileDialog = FileDialog.new()
	fileDial.add_filter("*.tscn")
	fileDial.use_native_dialog = true
	fileDial.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fileDial.access = FileDialog.ACCESS_FILESYSTEM
	
	fileDial.file_selected.connect(_customLevelSelect)
	add_child(fileDial)
	fileDial.show()

func _customLevelSelect(path:String):
	if $SettingsManager.getSetting("customLevelsWarningConfirmed"):
		_levelSelected("Custom Level", path)
	else:
		$LoadCustomLevelWaringPanel.show()
		$LoadCustomLevelWaringPanel.back.connect(func():
			for i in $LoadCustomLevelWaringPanel.back.get_connections():
				if i.signal.is_connected(i.callable):
					i.signal.disconnect(i.callable)
			for i in $LoadCustomLevelWaringPanel.confirm.get_connections():
				if i.signal.is_connected(i.callable):
					i.signal.disconnect(i.callable)
			$LoadCustomLevelWaringPanel.hide()
		)
		$LoadCustomLevelWaringPanel.confirm.connect(func():
			$LoadCustomLevelWaringPanel.hide()
			$SettingsManager.setSetting("customLevelsWarningConfirmed", true)
			_levelSelected("Custom Level", path))

func _on_button_level_editor_pressed():
	if get_node("/root").has_node("LevelEditor"):
		get_node("/root/LevelEditor").show()
		$MenuItems.hide()
		return
	
	var levelEditor = levelEditorScene.instantiate()
	levelEditor.exited.connect(func():
		levelEditor.queue_free()
		$MenuItems.show()
	)
	
	levelEditor.playLevel.connect(func(path:String):
		_levelSelected("Custom Editor Level", path)
	)
	
	get_node("/root").add_child(levelEditor)
	$MenuItems.hide()
