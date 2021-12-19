extends Area2D

onready var changer = get_parent().get_node("Trasition_in")

export var path : String

func _on_goal_body_entered(body):
	if body.name == "Player":
		$confetti.emitting = true
		$confetti2.emitting = true
		changer.change_scene(path)
		Global.checkpoint_pos = Vector2.ZERO
		$AudioStreamPlayer2D.play()
