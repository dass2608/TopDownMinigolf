extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_parent().get_node("PauseMenu").process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func pause():
	get_tree().paused = true
	get_parent().get_node("PauseMenu").visible = true
	get_parent().get_node("PauseMenu").move_to_front()
func unpause():
	get_tree().paused = false
	get_parent().get_node("PauseMenu").visible = false
	get_parent().mousePressed = false

func _unhandled_key_input(event):
	#print("[INPUT] GamePauseController: ", event)
	if event.is_action_pressed("pauseGame"):
		if not get_tree().paused:
			pause()
		else:
			unpause()


func _on_button_unpause_pressed():
#	print("\"Back to Game pressed\"")
	unpause()
