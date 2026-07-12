extends Node3D

@onready var label := $"../../CanvasLayer/cameraUi/outer/MarginContainer/inner/photoLabel"
@onready var viewfinder := $"../../CanvasLayer/cameraUi"

@export var photos = 5

var cameraUp = false
var remainingPhotos
var photosMade = []

func _ready():
	remainingPhotos = photos
	label.text = str(remainingPhotos)

func _input(event):
	if event.is_action_pressed("camera"):
		toggle_camera()

	if event.is_action_pressed("photo"):
		if cameraUp:
			make_photo()

func toggle_camera():
	if cameraUp:
		viewfinder.visible = false
		cameraUp = false
	else:
		viewfinder.visible = true
		cameraUp = true

func make_photo():
	var image = get_viewport().get_texture().get_image()
	photosMade.append(image)
	
	remainingPhotos -= 1
	label.text = str(remainingPhotos)
	
