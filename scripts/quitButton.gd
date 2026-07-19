extends Button

func _pressed():
	$"../../../../../../../../AudioStreamPlayer".stop()
	AudioManager.play_sound(preload("res://src/sounds/oxidvideos-transition-sfx-2-409073.mp3"), -15)
	get_tree().change_scene_to_file("res://scenes/quit.tscn")
