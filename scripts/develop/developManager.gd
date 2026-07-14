extends Node2D

@onready var polaroid := $CanvasLayer/polaroid
@onready var scoreView = $CanvasLayer/scoreView

var lastPhoto

func _ready():
	lastPhoto = 0
	polaroid.next_photo(lastPhoto)

func next():
	lastPhoto += 1
	scoreView.show_full_score(lastPhoto)
