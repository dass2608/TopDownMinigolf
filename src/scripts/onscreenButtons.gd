extends Control

signal left
signal right
signal up
signal down

var Xdisabled:bool = false:
	set(newValue):
		Xdisabled = newValue
		if newValue:
			$Left.hide()
			$Right.hide()
var Ydisabled:bool = false:
	set(newValue):
		Ydisabled = newValue
		if newValue:
			$Up.hide()
			$Down.hide()


func _on_up_button_down():
	Input.action_press("ui_up")
func _on_up_button_up():
	Input.action_release("ui_up")
func _on_down_button_down():
	Input.action_press("ui_down")
func _on_down_button_up():
	Input.action_release("ui_down")
func _on_left_button_down():
	Input.action_press("ui_left")
func _on_left_button_up():
	Input.action_release("ui_left")
func _on_right_button_down():
	Input.action_press("ui_right")
func _on_right_button_up():
	Input.action_release("ui_right")
