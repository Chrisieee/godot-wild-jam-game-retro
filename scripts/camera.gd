extends Node3D

var viewfinder
var cameraUp = false

func toggle_camera():
	viewfinder = get_tree().current_scene.get_node("player/CanvasLayer/cameraUi")
	
	if cameraUp:
		viewfinder.visible = false
		cameraUp = false
	else:
		viewfinder.visible = true
		cameraUp = true
	
