extends PanelContainer

@onready var settingsManager:Node = get_parent().get_parent().get_node("SettingsManager")
@onready var enableLineButton:CheckButton = $"VBoxContainer/TabContainer/Helper Line/VBoxContainer/CheckButtonEnableLine"
@onready var lineWidthSlider:HSlider = $"VBoxContainer/TabContainer/Helper Line/VBoxContainer/HBoxContainer/HSlider"
@onready var lineColorPicker:ColorPickerButton = $"VBoxContainer/TabContainer/Helper Line/VBoxContainer/HBoxContainerColor/ColorPicker"

func _ready():
	hide()


func _on_visibility_changed():
	if visible:
		enableLineButton.button_pressed = settingsManager.settings.helperLineEnabled
		lineWidthSlider.value = settingsManager.settings.helperLineWidth
		lineColorPicker.color = settingsManager.settings.helperLineColor


func _on_check_button_enable_line_toggled(toggled_on):
	settingsManager.setSetting("helperLineEnabled", toggled_on)


func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		settingsManager.setSetting("helperLineWidth", lineWidthSlider.value)


func _on_color_picker_color_changed(color):
	settingsManager.setSetting("helperLineColor", color)


func _on_button_back_pressed():
	hide()
