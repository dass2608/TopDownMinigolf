extends Node2D

signal triggered

func _on_static_body_2d_body_entered(body):
	if body is RigidBody2D:
		triggered.emit()
