extends Node2D

signal nextLevel
signal cancelLevel

@onready var movablePillarsEnabled = self.has_node("MovablePillars")
@onready var LockXmovement = self.has_node("DisableXmovement")
@onready var LockYmovement = self.has_node("DisableYmovement")

func _ready():
	$TextureRect.hide()

func _physics_process(_delta):
	if !movablePillarsEnabled: return
	if Input.is_action_pressed("ui_right") and !LockXmovement:
		$MovablePillars.position.x += 1
	if Input.is_action_pressed("ui_left") and !LockXmovement:
		$MovablePillars.position.x -= 1
	if Input.is_action_pressed("ui_up") and !LockYmovement:
		$MovablePillars.position.y -= 1
	if Input.is_action_pressed("ui_down") and !LockYmovement:
		$MovablePillars.position.y += 1

func _on_hole_body_entered(_body):
	emit_signal("nextLevel")

func _on_death_pad_triggered():
	cancelLevel.emit()
