extends Panel

@onready var polaroid := $"../polaroid"
@onready var scorePolaroid = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid
@onready var mask = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/MarginContainer/Overlay
@onready var texture = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/MarginContainer/Panel/TextureRect
@onready var label = $MarginContainer/VBoxContainer/HBoxContainer/scorePolaroid/Label

@export var scoreLabel: PackedScene
@export var scoreLabelEnd: PackedScene

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
	var labels = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer.get_children()
	for l in labels:
		l.queue_free()
	
	for reason in PhotoManager.photos[photo - 1].scoreReasons:
		var newLabel = scoreLabel.instantiate()
		
		newLabel.get_node("Label").text = reason.name
		newLabel.get_node("Label2").text = "+ %d" % [reason.points]
		
		$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer.add_child(newLabel)
		
	var newLabel = scoreLabelEnd.instantiate()
	newLabel.get_node("Label2").text = str(PhotoManager.photos[photo - 1].score)
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer.add_child(newLabel)
