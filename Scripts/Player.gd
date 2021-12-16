extends KinematicBody2D

var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 20
var jump_force = -720
var is_grounded
var player_health = 3
var max_health = 3
var is_hurted = false
var knockback_direction = 1
var knockback_int = 600
onready var raycasts = $Raycasts

signal change_life(player_health)

func _ready():
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/Holder"), "onChangeLife")
	emit_signal("change_life", max_health)
	
	position = Global.checkpoint_pos if Global.checkpoint_pos != Vector2.ZERO else position

func _physics_process(_delta):
	velocity.y += gravity
	velocity.x = 0
	
	if !is_hurted:
		_get_input()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	is_grounded = _check_is_ground()
	
	_set_animation()
	
	for platform in get_slide_count():
		var collision = get_slide_collision(platform)
		if (collision.collider.has_method("collide_with")):
			collision.collider.collide_with(collision, self)

func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	
	if move_direction != 0:
		$Texture.scale.x = move_direction
		knockback_direction = move_direction
		$step_fx.scale.x = move_direction

func knockback():
	
	if $left.is_colliding():
		velocity.x += knockback_direction * knockback_int
	if $right.is_colliding():
		velocity.x -= knockback_direction * knockback_int	
	
	velocity = move_and_slide(velocity)

func _input(event):
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jump_force / 1.5
		
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0:
		anim = "run"
		$step_fx.set_emitting(true)
	
	if velocity.y > 0 and !is_grounded:
		anim = "fall"
	
	if is_hurted:
		anim = "hit"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_Button7_button_down():
	var a = InputEventAction.new()
	a.action = "move_right"
	a.pressed = true
	Input.parse_input_event(a)


func _on_Button7_button_up():
	var a = InputEventAction.new()
	a.action = "move_right"
	a.pressed = false
	Input.parse_input_event(a)


func _on_Button6_button_up():
	var a = InputEventAction.new()
	a.action = "move_left"
	a.pressed = false
	Input.parse_input_event(a)


func _on_Button6_button_down():
	var a = InputEventAction.new()
	a.action = "move_left"
	a.pressed = true
	Input.parse_input_event(a)


func _on_Button4_button_down():
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = true
	Input.parse_input_event(a)


func _on_Button4_button_up():
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = false
	Input.parse_input_event(a)



func _on_hurtbox_body_entered(_body):
	player_health -= 1
	is_hurted = true
	emit_signal("change_life", player_health)
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.6), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)
	is_hurted = false
	
	if player_health <= 0:
		queue_free()
		get_tree().reload_current_scene()

func hit_checkpoint():
	Global.checkpoint_pos = position


func _on_Area2D_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()
