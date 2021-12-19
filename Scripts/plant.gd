extends KinematicBody2D

var is_facing_left = true

onready var bullet_instance = preload("res://Scenes/bullet.tscn")
onready var player = Global.get("player")
var is_hitted = false
var health = 3

func _physics_process(_delta):
	_set_animation()
	
	if player:
		var distance = player.global_position.x - self.position.x
		is_facing_left = true if distance < 0 else false
	
	if is_facing_left:
		self.scale.x = 1
	else:
		self.scale.x = -1
		
func shoot():
	var bullet = bullet_instance.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $spawnShoot.global_position
	if is_facing_left:
		bullet.direction = 1
	else:
		bullet.direction = -1

func _set_animation():
	var anim = "run"
	
	if $playerDetector.overlaps_body(player):
		anim = "attack"
	else:
		anim = "idle"
	
	if is_hitted:
		anim = "hit"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_playerDetector_body_entered(_body):
	$anim.play("attack")


func _on_playerDetector_body_exited(_body):
	$anim.play("idle")


func _on_hitbox_body_entered(body):
	is_hitted = true
	health -= 1
	body.velocity.y = body.jump_force / 2
	yield(get_tree().create_timer(0.2), "timeout")
	is_hitted = false
	$hit_sound.play()
	if health <= 0:
#		get_node("Hitbox/collision").set_deferred("disabled", true)
		queue_free()
