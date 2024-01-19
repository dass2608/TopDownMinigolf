extends PanelContainer

signal confirm
signal back

func _on_button_continue_pressed():
	confirm.emit()


func _on_button_back_pressed():
	back.emit()
