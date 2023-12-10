extends Area2D

const CLAMP_MAX = 250

func _on_body_entered(body:RigidBody2D):
#	print("Veclocity was: ", body.linear_velocity)
	body.apply_impulse(body.linear_velocity.clamp(Vector2(-CLAMP_MAX, -CLAMP_MAX), Vector2(CLAMP_MAX, CLAMP_MAX)))
