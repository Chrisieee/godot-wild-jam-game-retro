extends Button

@onready var scoreView = $"../../.."
@onready var polaroid := $"../../../../polaroid"
var lastPhoto

func _pressed():
	scoreView.visible = false
	polaroid.visible = true
	
	polaroid.next_photo(lastPhoto)
