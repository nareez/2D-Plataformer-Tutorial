extends KinematicBody2D

export var speed = 64
export var health = 3
var motion = Vector2.ZERO
var move_direction = -1
var gravity = 20
var is_hitted = false

func _physics_process(_delta):
	motion.x = speed * move_direction
	motion.y += gravity
	
	if move_direction == 1:
		$texture.flip_h = true
	else:
		$texture.flip_h = false
	
	if $ray_wall.is_colliding():
		$anim.play("idle")
		
	_set_animation()
	motion = move_and_slide(motion)

func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		$ray_wall.scale.x *= -1
		move_direction *= -1
		$anim.play("run")

func _set_animation():
	var anim = "run"
	
	if $ray_wall.is_colliding():
		anim = "idle"
	elif motion.x != 0:
		anim = "run"
	
	if is_hitted:
		anim = "hit"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_Hitbox_body_entered(body):
	is_hitted = true
	health -= 1
	body.velocity.y = body.jump_force / 2
	yield(get_tree().create_timer(0.2), "timeout")
	is_hitted = false
	
	if health <= 0:
		queue_free()
		get_node("Hitbox/collision").set_deferred("disabled", true)
