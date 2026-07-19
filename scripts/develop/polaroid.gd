extends Panel

@onready var scoreLabel = $polScoreLabel
@onready var mask = $MarginContainer/Overlay
@onready var scoreView = $"../../.."
@onready var scratchSound = $AudioStreamPlayer

var startPosition: Vector2
var endPosition

var progress = 0.0
var lastMouse = Vector2.ZERO

var callingNext = false
var photoId = 0
var scratch_timer := 0.0

func _ready():
	scratchSound.play()
	print("Playing:", scratchSound.playing)
	startPosition = position
	endPosition = Vector2(-400, 800)

func _process(delta):
	var mouse = get_viewport().get_mouse_position()
	var movement = mouse.distance_to(lastMouse)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if movement > 0:
			scratch_timer = 0.1

			if !scratchSound.playing:
				scratchSound.play()

			progress += movement * 0.0001
			progress = clamp(progress, 0.0, 1.0)
			mask.modulate.a = lerp(1.0, 0.0, progress)

	scratch_timer -= delta

	if scratch_timer <= 0 and scratchSound.playing:
		scratchSound.stop()
	
	if progress == 1 && not callingNext: 
		callingNext = true 
		show_score() 
		lastMouse = mouse

func show_score():
	scoreLabel.visible = true
	await get_tree().create_timer(2).timeout
	
	if photoId + 1 <= PhotoManager.photos.size():
		$"../..".next()

func next_photo(photo):
	if photo != 0:
		var tween = create_tween()

		tween.tween_interval(1.0)
		tween.tween_property(self, "position", endPosition, 0.7)

		await tween.finished
		callingNext = false
		photoId = photo
	
	if photoId >= PhotoManager.photos.size():
		print("klaar")
		PhotoManager.photos.clear()
		$"../donePopup".visible = true
		return
	else:
		scoreLabel.visible = false
		position = startPosition
		rotation = 0
		scale = Vector2.ONE
		modulate.a = 1.0
		visible = true
		progress = 0.0
		mask.modulate.a = lerp(1.0, 0.0, progress)

		$MarginContainer/Panel/TextureRect.texture = PhotoManager.photos[photo].texture
	
		var bias = Time.get_time_zone_from_system().bias * 60
		var localTime = PhotoManager.photos[photo].timeTaken + bias
	
		var date = Time.get_datetime_dict_from_unix_time(localTime)
		$Label.text = "%02d-%02d-%04d %02d:%02d:%02d" % [date.day, date.month, date.year, date.hour, date.minute, date.second]
	
		var string = "Score: %d" % [PhotoManager.photos[photo].score]
		scoreLabel.text = string
