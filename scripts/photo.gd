extends Panel

var startPosition: Vector2
var endPosition

func _ready():
	startPosition = position
	endPosition = Vector2(-400, 800)
	visible = false

func show_photo(photo):
	$MarginContainer/Panel/TextureRect.texture = photo.texture
	
	position = startPosition
	rotation = 0
	scale = Vector2.ONE
	modulate.a = 1.0
	visible = true
	
	var bias = Time.get_time_zone_from_system().bias * 60
	var localTime = photo.timeTaken + bias
	
	var date = Time.get_datetime_dict_from_unix_time(localTime)
	$Label.text = "%02d-%02d-%04d %02d:%02d:%02d" % [date.day, date.month, date.year, date.hour, date.minute, date.second]
	
	visible = true
	
	var tween = create_tween()

	tween.tween_interval(1.0)
	tween.tween_property(self, "position", endPosition, 0.7)

	await tween.finished
	visible = false
