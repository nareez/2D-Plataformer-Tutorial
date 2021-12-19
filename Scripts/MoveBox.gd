extends KinematicBody2D

var gravity = 20
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity) 

func _ready():
	pass
