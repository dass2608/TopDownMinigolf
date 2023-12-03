extends RigidBody2D

@export var mu_static :float = 80  # friction coefficients
@export var mu_moving :float = 50  # pushing something moving is easier

@export var move_strength:int = 50

var applied_forces: Vector2 = Vector2(0, 0)

func add_force_for_frame(force: Vector2):
	applied_forces += force
	self.apply_central_force(force)

func _ready() -> void:
	self.gravity_scale = 0

func _physics_process(_delta):
	if self.linear_velocity.length() == 0:
		self.add_force_for_frame(-mass * mu_static * self.linear_velocity.normalized())
	else:
		self.add_force_for_frame(-mass * mu_moving * self.linear_velocity.normalized())
