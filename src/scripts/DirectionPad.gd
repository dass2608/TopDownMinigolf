@tool
extends Node2D

@export var direction:Directions:
	set(new_value):
		direction = new_value
		_ready()
## The power of the applied impulse. THis will bw multiplied by 100 to be used as impulse
@export var strength:float = 1:
	set(new_value):
		strength = new_value
		update_configuration_warnings()
## If enabled, any motion the player has will be nullified before the impulse is applied
@export var nullifySpeed:bool = false:
	set(new_value):
		nullifySpeed = new_value
		_ready()

var impulse:Vector2
const IMPULSE_MULTIPLIER:int = 100

enum Directions {
	UP = 0,
	DOWN,
	LEFT,
	RIGHT
}

func _get_configuration_warnings():
	var warnings = []
	
	if strength <= 0:
		warnings.append("Setting the Strength to 0 or below might cause unintended behavior!")
	
	return warnings

func _ready():
	match direction:
		Directions.UP:
			impulse = Vector2(0, -strength * IMPULSE_MULTIPLIER)
			$StaticBody2D.rotation = deg_to_rad(0)
		Directions.DOWN:
			impulse = Vector2(0, strength * IMPULSE_MULTIPLIER)
			$StaticBody2D.rotation = deg_to_rad(180)
		Directions.LEFT:
			impulse = Vector2(-strength * IMPULSE_MULTIPLIER, 0)
			$StaticBody2D.rotation = deg_to_rad(-90)
		Directions.RIGHT:
			impulse = Vector2(strength * IMPULSE_MULTIPLIER, 0)
			$StaticBody2D.rotation = deg_to_rad(90)
	if nullifySpeed:
		$StaticBody2D/Sprite2D.modulate = Color("ff8bff")
	else:
		$StaticBody2D/Sprite2D.modulate = Color("ffffff")

func _on_static_body_2d_body_entered(body:RigidBody2D):
	if nullifySpeed:
		body.linear_velocity = Vector2.ZERO
	body.apply_impulse(impulse)
