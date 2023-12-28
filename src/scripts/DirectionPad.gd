@tool
extends Node2D

@export var direction:Directions
@export var strength:float = 1

var impulse:Vector2
const IMPULSE_MULTIPLIER:int = 100

enum Directions {
	UP = 0,
	DOWN,
	LEFT,
	RIGHT
}

func _ready():
	match direction:
		Directions.UP:
			impulse = Vector2(0, -strength * IMPULSE_MULTIPLIER)
			$StaticBody2D.rotation = deg_to_rad(0)
		Directions.DOWN:
			impulse = Vector2(0, strength * IMPULSE_MULTIPLIER)
			$StaticBody2D.rotation += deg_to_rad(180)
		Directions.LEFT:
			impulse = Vector2(-strength * IMPULSE_MULTIPLIER, 0)
			$StaticBody2D.rotation += deg_to_rad(-90)
		Directions.RIGHT:
			impulse = Vector2(strength * IMPULSE_MULTIPLIER, 0)
			$StaticBody2D.rotation += deg_to_rad(90)

func _on_static_body_2d_body_entered(body:RigidBody2D):
	body.apply_impulse(impulse)
