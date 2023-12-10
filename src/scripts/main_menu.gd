extends Control

const gameScene = preload("res://src/scenes/game.tscn")

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


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	var levelArray = getLevelArray()
	for i in levelArray:
		var buttonNode = load("res://src/scenes/level_button.tscn").instantiate()
		buttonNode.text = i.split(".", false, 1)[0]
		buttonNode.add_theme_font_size_override(&"font_size", 32)
		buttonNode.flat = true
		buttonNode.connect(&"selected", _levelSelected)
		$MenuItems/PanelLevelselect/ScrollContainer/VBoxContainer.add_child(buttonNode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_play_pressed():
	$MenuItems/PanelLevelselect.show()

func _levelSelected(levelName:String):
	var game = gameScene.instantiate()
	game.loadLevel(levelName)
	game.connect(&"levelCompleted", _levelDone)
	add_child(game, true)
	$MenuItems.hide()
	$MenuItems/PanelLevelselect.hide()

func _levelDone(shots:int, level:String):
	for i in get_children():
		if i.name == "Game":
			i.queue_free()
			$MenuItems.show()
	$MenuItems/LabelLevelComplete.text = level.trim_suffix(".tscn") + " completed in " + str(shots) + " shots!"



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
