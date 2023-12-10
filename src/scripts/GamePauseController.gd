extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("pauseGame"):
		if not get_tree().paused:
			get_tree().paused = true
			get_parent().get_node("LabelGamePaused").visible = true
		else:
			get_tree().paused = false
			get_parent().get_node("LabelGamePaused").visible = false
			get_parent().mousePressed = false
