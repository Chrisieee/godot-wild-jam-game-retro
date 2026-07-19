extends Node3D

@onready var label = $"../../CanvasLayer/cameraUi/outer/MarginContainer/inner/photoLabel"
@onready var viewfinder = $"../../CanvasLayer/cameraUi"
@onready var playerCamera = $"../Camera3D"
@onready var photoCamera = $"../SubViewport/photoCamera"
@onready var polaroidPhoto = $"../../CanvasLayer/photoUi"
@onready var cameraModel = $"../Camera3D/camera2"

@export var photos = 5

var cameraUp = false
var remainingPhotos
var photosMade = []

func _ready():
	$"../../CanvasLayer/cameraUi/noPhotoLabel".visible = false
	viewfinder.visible = false
	remainingPhotos = photos
	label.text = str(remainingPhotos)

func _process(_delta):
	photoCamera.global_transform = playerCamera.global_transform

func raise_camera():
	AudioManager.play_sound(preload("res://src/sounds/pickingup.mp3"), 0)
	$"../../../CanvasLayer/controlsView".visible = false
	viewfinder.visible = true
	cameraUp = true
	cameraModel.visible = false

func lower_camera():
	AudioManager.play_sound(preload("res://src/sounds/Puttingdown.mp3"), -15)
	$"../../../CanvasLayer/controlsView".visible = true
	viewfinder.visible = false
	cameraUp = false
	cameraModel.visible = true

func make_photo():
	if remainingPhotos > 0:
		AudioManager.play_sound(preload("res://src/sounds/irinairinafomicheva-camera-13695.mp3"), -5)
		var photo := PhotoData.new()
	
		photo.image = $"../SubViewport".get_texture().get_image()
		photo.texture = ImageTexture.create_from_image(photo.image)
		photo.timeTaken = Time.get_unix_time_from_system()
		photo.map = GameManager.map
	
		PhotoManager.photos.append(photo)
	
		remainingPhotos -= 1
		label.text = str(remainingPhotos)
	
		photo.score = ScoreManager.calculate_score(photo)
	
		print(photo.score)
	
		lower_camera()
	
		polaroidPhoto.show_photo(photo)
	else:
		print("No more pictures")
		$"../../CanvasLayer/cameraUi/noPhotoLabel".visible = true
