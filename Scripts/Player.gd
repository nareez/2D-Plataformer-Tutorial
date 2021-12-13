extends KinematicBody2D

var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 20
var jump_force = -720
var is_grounded
var health = 3
var is_hurted = false
var knockback_direction = 1
var knockback_int = 600
onready var raycasts = $Raycasts

func _physics_process(_delta):
	velocity.y += gravity

	_get_input()
	
	velocity = move_and_slide(velocity)
	
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
	
	if velocity.y > 0 and !is_grounded:
		anim = "fall"
	
	if is_hurted:
		anim = "hit"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _ready():
	pass



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

func knockback():
	velocity.x = -knockback_direction * knockback_int
	velocity = move_and_slide(velocity)

func _on_hurtbox_body_entered(_body):
	health -= 1
	is_hurted = true
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)
	is_hurted = false
	
	if health <= 0:
		queue_free()
		get_tree().reload_current_scene()
