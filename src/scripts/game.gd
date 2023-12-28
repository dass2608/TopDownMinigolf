extends Node2D

signal levelCompleted(shots:int, levelname:String)
signal levelAborted
signal levelRestarted(levelname:String)

var settings:Dictionary = {}
var enableXcontrolButtons:bool = true
var enableYcontrolButtons:bool = true

var mousePosition:Vector2
var mousePressed = false
var shots:int = 0
var levelname:String = ""

func _unhandled_input(event):
	#print("[INPUT] game.gd _unhandled_input: ", event)
	if event is InputEventMouseButton:
		if event.is_pressed():
			var mask = event.button_mask
			var isLeftClicked = mask & MOUSE_BUTTON_MASK_LEFT
			#print("Mousclick! Mask: ", mask, "; Leftclick? = ", isLeftClicked > 0)
			if isLeftClicked == 0: return
			mousePosition = get_local_mouse_position()
			mousePressed = true
			shots += 1
			$LabelShots.text = "Shots: " + str(shots)
		elif event.is_released() and mousePressed:
			var mouseReleasePosition:Vector2 = get_local_mouse_position()
			$Player.apply_impulse((mousePosition - mouseReleasePosition) * 2)
			mousePressed = false
	elif event is InputEventMouseMotion:
		queue_redraw()

func _draw():
	if mousePressed and settings.helperLineEnabled:
		draw_line(mousePosition, get_local_mouse_position(), settings.helperLineColor, settings.helperLineWidth, true)

func loadLevel(levelName:String):
	var level:Node2D = load("res://src/scenes/levels/" + levelName).instantiate()
	level.connect(&"nextLevel", _onLevelCompleted)
	level.cancelLevel.connect(func(): levelAborted.emit())
	if level.has_node("PlayerStartPosition"):
		$Player.position = level.get_node("PlayerStartPosition").position
	
	if settings.onscreenButtonsEnabled:
		if !level.has_node("MovablePillars"):
			enableXcontrolButtons = false
			enableYcontrolButtons = false
		if level.has_node("DisableXmovement"):
			enableXcontrolButtons = false
		if level.has_node("DisableYmovement"):
			enableYcontrolButtons = false
	else:
		enableXcontrolButtons = false
		enableYcontrolButtons = false
	
	level.show_behind_parent = true
	add_child(level)
	levelname = levelName
	
	$OnscreenButtons.Xdisabled = !enableXcontrolButtons
	$OnscreenButtons.Ydisabled = !enableYcontrolButtons

func loadSettings(new_settings:Dictionary):
	settings = new_settings

func _onLevelCompleted():
	print("Level Completed!")
	emit_signal("levelCompleted", shots, levelname)

func _on_button_main_menu_pressed():
	levelAborted.emit()
	$GamePauseController.unpause()

func _on_button_restart_level_pressed():
	$GamePauseController.unpause()
	levelRestarted.emit(levelname)

func _on_pause_button_pressed():
	$GamePauseController.pause()
