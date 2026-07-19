extends Node2D

@onready var polaroid := $CanvasLayer/polaroid
@onready var scoreView = $CanvasLayer/scoreView

var lastPhoto

func _ready():
	$AudioStreamPlayer.play()
	
	lastPhoto = 0
	polaroid.next_photo(lastPhoto)
	$CanvasLayer/donePopup.visible = false
	scoreView.visible = false

func next():
	lastPhoto += 1
	scoreView.show_full_score(lastPhoto)

func _input(event):
	if event.is_action_pressed("develop"):
		$AudioStreamPlayer.stop()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
