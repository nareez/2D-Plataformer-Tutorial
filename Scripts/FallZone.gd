extends Area2D


func _ready():
	pass


func _on_FallZone_body_entered(_body):
	get_tree().change_scene("res://Prefabs/GameOver.tscn")
