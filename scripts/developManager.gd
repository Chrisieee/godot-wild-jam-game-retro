extends Node2D

@onready var polaroid := $CanvasLayer/polaroid/MarginContainer/Panel/TextureRect
@onready var label := $CanvasLayer/polaroid/Label

var lastPhoto

func _ready():
	polaroid.texture = PhotoManager.photos[0].texture
	var bias = Time.get_time_zone_from_system().bias * 60
	var localTime = PhotoManager.photos[0].timeTaken + bias
	
	var date = Time.get_datetime_dict_from_unix_time(localTime)
	label.text = "%02d-%02d-%04d %02d:%02d:%02d" % [date.day, date.month, date.year, date.hour, date.minute, date.second]
	
	lastPhoto = 0

func next():
	lastPhoto += 1
	$CanvasLayer/polaroid.next_photo(lastPhoto)
