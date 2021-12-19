extends Area2D


func _on_trampolim_body_entered(body):
	body.velocity.y = body.jump_force / 1.3
	$anim.play("jump")
