class_name InspectorItem
extends VBoxContainer

@warning_ignore("shadowed_variable_base_class")
func setElementName(name:String):
	$LabelTitle.text = name

@warning_ignore("shadowed_variable_base_class")
func add_property(name:String, type:int, callback:Callable, dropdownEnum = null):
	var container:HBoxContainer = _getContainer(name)
	if type == TYPE_BOOL:
		var checkbox:CheckBox = CheckBox.new()
		checkbox.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_END
		checkbox.toggled.connect(callback)
		container.add_child(checkbox)
	elif type == TYPE_FLOAT:
		var spinbox:SpinBox = SpinBox.new()
		spinbox.step = 0.1
		spinbox.size_flags_horizontal |= Control.SIZE_EXPAND
		spinbox.value_changed.connect(callback)
		container.add_child(spinbox)
	elif type == TYPE_INT and dropdownEnum != null:
		var optbtn:OptionButton = OptionButton.new()
		optbtn.allow_reselect = true
		for i in dropdownEnum:
			i = i.split(":")[0]
			optbtn.add_item(i)
		optbtn.item_selected.connect(callback)
		container.add_child(optbtn)
	else:
		assert(false, "Type not yet implemented or set wrong...\nType was: " + str(type))
		return
	
	%PropContainer.add_child(container)

func _getContainer(text:String) -> HBoxContainer:
	var container := HBoxContainer.new()
	var label := Label.new()
	label.text = text
	container.add_child(label)
	return container
