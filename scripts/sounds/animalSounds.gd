extends AudioStreamPlayer3D

func _process(_delta: float) -> void:
	if !playing:
		play()
