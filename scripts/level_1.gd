extends Node3D

func _ready():
	GameManager.map = "forest"

func _input(event):
	if event.is_action_pressed("develop"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/develop.tscn")
