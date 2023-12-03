extends Node2D

signal nextLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_hole_body_entered(_body):
	emit_signal("nextLevel")
