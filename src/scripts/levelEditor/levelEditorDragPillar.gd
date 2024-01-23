class_name DragablePillar
extends Area2D

var dragging:bool = false

func _input(event):
	if event is InputEventMouseMotion and dragging:
		get_parent().position = get_parent().get_parent().get_local_mouse_position()

func _ready():
	input_event.connect(_on_input)

func _on_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and get_parent().get_parent().get_parent().editorMode:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging = true
			get_viewport().set_input_as_handled()
			#print("Mouse pressed")
		else:
			#print("Mouse released")
			get_viewport().set_input_as_handled()
			dragging = false
