extends Control

signal exited
signal playLevel(path:String)

const levelTemplateScene = preload("res://src/scenes/templates/levelEditorTemplate.tscn")
const greyPillarScene = preload("res://src/scenes/levelComponents/GrayPillar.tscn")
const BLACK_PILLAR = preload("res://src/scenes/levelComponents/BlackPillar.tscn")
const ACCELERATION_PAD = preload("res://src/scenes/levelComponents/AccelerationPad.tscn")
const DEATH_PAD = preload("res://src/scenes/levelComponents/DeathPad.tscn")
const LIGHTBLUE_PILLAR = preload("res://src/scenes/levelComponents/LightbluePillar.tscn")
const DARKBLUE_PILLAR = preload("res://src/scenes/levelComponents/DarkbluePillar.tscn")
const DIRECTION_PAD = preload("res://src/scenes/levelComponents/DirectionPad.tscn")

const INSPECTOR_ITEM = preload("res://src/scenes/inspector_item.tscn")

const scaleFactor = 0.8

var editableProsNode:Array[Node] = []
var currentPath:String = ""

func _ready():
	var level = levelTemplateScene.instantiate()
	level.editorMode = true
	level.scale = Vector2(scaleFactor, scaleFactor)
	
	%LevelContainer.add_child(level)
	updateEditables()


func _on_button_normal_wall_pressed():
	var scene:Node2D = greyPillarScene.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)


func _on_button_stick_wall_pressed():
	var scene:Node2D = BLACK_PILLAR.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)


func _on_button_accelerate_pad_pressed():
	var scene:Node2D = ACCELERATION_PAD.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)


func _on_button_death_pad_pressed():
	var scene:Node2D = DEATH_PAD.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	scene.scale = Vector2(1.25, 1.25)
	scene.triggered.connect(%LevelContainer.get_child(0)._on_death_pad_triggered, CONNECT_PERSIST)
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)


func _on_button_lightblue_pillar_pressed():
	var scene:Node2D = LIGHTBLUE_PILLAR.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddMovablePillar(scene)


func _on_button_darkblue_pillar_pressed():
	var scene:Node2D = DARKBLUE_PILLAR.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddMovablePillar(scene)

func _on_button_direction_pad_pressed():
	var scene:Node2D = DIRECTION_PAD.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)
	updateEditables()

func updateEditables():
	editableProsNode = []
	for i in %EditablesConatiner.get_children():
		i.queue_free()
	# Wait until Nodes are destroyed
	await get_tree().process_frame
	editableProsNode = findNodesOfGroupRecursive(%LevelContainer, "LevelEditorPropsEditable")
	
	for i in editableProsNode:
		var propertyList = i.get_property_list()
		var inspectorItem:InspectorItem = INSPECTOR_ITEM.instantiate()
		
		# TODO: Get a name for the Direction Pad somehow
		inspectorItem.setElementName("Direction Pad")
		%EditablesConatiner.add_child(inspectorItem)
		
		for j in propertyList.size():
			# Get only @exported properties (hopefully)
			if propertyList[j].usage & (PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE) == PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE:
				if not propertyList[j].hint == PROPERTY_HINT_ENUM:
					inspectorItem.add_property(propertyList[j].name, propertyList[j].type, func(arg): i[propertyList[j].name] = arg)
				else:
					inspectorItem.add_property(propertyList[j].name, propertyList[j].type, func(arg): i[propertyList[j].name] = arg, propertyList[j].hint_string.split(","))

func findNodesOfGroupRecursive(base:Node, group:String) -> Array[Node]:
	var arr:Array[Node] = []
	for i in base.get_children():
		if i.is_in_group(group):
			arr.append(i)
		arr.append_array(findNodesOfGroupRecursive(i, group))
	return arr


func _on_button_save_level_pressed():
	if currentPath != "":
		saveLevel(currentPath)
		return
	
	var fileDial:FileDialog = FileDialog.new()
	fileDial.add_filter("*.tscn")
	fileDial.use_native_dialog = true
	fileDial.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	fileDial.access = FileDialog.ACCESS_FILESYSTEM
	
	fileDial.file_selected.connect(saveLevel)
	fileDial.file_selected.connect(func(path:String): currentPath = path)
	add_child(fileDial)
	fileDial.show()

func saveLevel(path:String) -> String:
	var scene = PackedScene.new()
	var level = %LevelContainer.get_child(0).duplicate()
	level.editorMode = false
	level.scale = Vector2(1, 1)
	_setOwnerRecursive(level, level)
	
	scene.pack(level)
	ResourceSaver.save(scene, path)
	return path

func _setOwnerRecursive(node:Node, newOwner:Node):
	for i in node.get_children():
		i.owner = newOwner
		#print("Set owner of " + str(node) + " to " + str(newOwner))
		_setOwnerRecursive(i, newOwner)


func _on_button_quit_pressed():
	_on_button_save_level_pressed()
	exited.emit()

func _on_button_play_pressed():
	hide()
	
	if currentPath != "":
		playLevel.emit(currentPath)
		return
	var fileDial:FileDialog = FileDialog.new()
	fileDial.add_filter("*.tscn")
	fileDial.use_native_dialog = true
	fileDial.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	fileDial.access = FileDialog.ACCESS_FILESYSTEM
	
	fileDial.file_selected.connect(func(path:String): playLevel.emit(path))
	add_child(fileDial)
	fileDial.show()
