extends Control

export (int) var minutes = 0
export (int) var seconds = 0

func _process(delta):
	if minutes > 0 and seconds <=0:
		minutes -= 1
		seconds = 59
	
	$time.set_text("%02d:%02d" % [minutes, seconds])
	

func _ready():
	pass


func _on_Timer_timeout():
	if seconds > 0 :
		seconds -= 1
	else:
		yield(get_tree().create_timer(1), "timeout")
		get_tree().reload_current_scene()
	
