extends CanvasLayer



func _on_BtnRetry_pressed():
	get_tree().change_scene("res://levels/Level_01.tscn")
	yield(get_tree(),"idle_frame")
	get_tree().reload_current_scene()
