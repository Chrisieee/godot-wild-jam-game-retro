extends CanvasLayer

var isVisible = true

func _ready():
	$controlsView.visible = true
	$controlsView2.visible = false

func _input(event):
	if event.is_action_pressed("hide_controls"):
		isVisible = !isVisible
		
		if isVisible:
			$controlsView.visible = true
			$controlsView2.visible = false
		else:
			$controlsView.visible = false
			$controlsView2.visible = true
