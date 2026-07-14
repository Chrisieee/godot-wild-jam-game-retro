extends Panel

@onready var polaroid := $"../polaroid"
@onready var scorePolaroid = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid
@onready var mask = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/MarginContainer/Overlay
@onready var texture = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/MarginContainer/Panel/TextureRect
@onready var label = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/Label
@onready var scoreLabelEnd = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/scoreLabelEnd

func show_full_score(photo):
	polaroid.visible = false
	mask.modulate.a = 0

	texture.texture = PhotoManager.photos[photo - 1].texture
	
	var bias = Time.get_time_zone_from_system().bias * 60
	var localTime = PhotoManager.photos[photo - 1].timeTaken + bias
	
	var date = Time.get_datetime_dict_from_unix_time(localTime)
	label.text = "%02d-%02d-%04d %02d:%02d:%02d" % [date.day, date.month, date.year, date.hour, date.minute, date.second]
	
	var string = "Score: %d" % [PhotoManager.photos[photo - 1].score]
	scorePolaroid.get_node("polScoreLabel").text = string
	scorePolaroid.get_node("polScoreLabel").visible = true
	
	visible = true
	
	show_score_reason(photo)
	
	$MarginContainer/VBoxContainer/Button.lastPhoto = photo

func show_score_reason(photo):
	scoreLabelEnd.get_node("Label2").text = str(PhotoManager.photos[photo - 1].score)
