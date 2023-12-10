extends Node2D

signal nextLevel

@onready var movablePillarsEnabled = self.has_node("MovablePillars")

func _physics_process(_delta):
	if !movablePillarsEnabled: return
	if Input.is_action_pressed("ui_right"):
		$MovablePillars.position.x += 1
	if Input.is_action_pressed("ui_left"):
		$MovablePillars.position.x -= 1
	if Input.is_action_pressed("ui_up"):
		$MovablePillars.position.y -= 1
	if Input.is_action_pressed("ui_down"):
		$MovablePillars.position.y += 1

func _on_hole_body_entered(_body):
	emit_signal("nextLevel")
