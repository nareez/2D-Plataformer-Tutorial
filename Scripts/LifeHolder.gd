extends Control

var life_size = 32

	
func onChangeLife(player_health):
	$lifes.rect_size.x = player_health * life_size
