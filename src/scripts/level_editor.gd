extends Control

const levelTemplateScene = preload("res://src/scenes/templates/levelEditorTemplate.tscn")
const greyPillarScene = preload("res://src/scenes/levelComponents/GrayPillar.tscn")
const BLACK_PILLAR = preload("res://src/scenes/levelComponents/BlackPillar.tscn")
const ACCELERATION_PAD = preload("res://src/scenes/levelComponents/AccelerationPad.tscn")
const DEATH_PAD = preload("res://src/scenes/levelComponents/DeathPad.tscn")
const LIGHTBLUE_PILLAR = preload("res://src/scenes/levelComponents/LightbluePillar.tscn")
const DARKBLUE_PILLAR = preload("res://src/scenes/levelComponents/DarkbluePillar.tscn")

const scaleFactor = 0.8

func _ready():
	var level = levelTemplateScene.instantiate()
	level.editorMode = true
	level.scale = Vector2(scaleFactor, scaleFactor)
	
	%LevelContainer.add_child(level)


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
	%LevelContainer.get_child(0).LevelEditorAddRegularPillar(scene)


func _on_button_lightblue_pillar_pressed():
	var scene:Node2D = LIGHTBLUE_PILLAR.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddMovablePillar(scene)


func _on_button_darkblue_pillar_pressed():
	var scene:Node2D = DARKBLUE_PILLAR.instantiate()
	scene.global_position = Vector2(get_global_mouse_position().x, get_global_mouse_position().y + 100)
	%LevelContainer.get_child(0).LevelEditorAddMovablePillar(scene)
