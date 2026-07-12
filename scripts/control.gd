extends Control

@export var corner_length := 20
@export var thickness := 4
@export var color := "#D8D8D8"

func _draw():
	var w = size.x
	var h = size.y

	# Linksboven
	draw_line(Vector2(0, 0), Vector2(corner_length, 0), color, thickness)
	draw_line(Vector2(0, 0), Vector2(0, corner_length), color, thickness)

	# Rechtsboven
	draw_line(Vector2(w, 0), Vector2(w - corner_length, 0), color, thickness)
	draw_line(Vector2(w, 0), Vector2(w, corner_length), color, thickness)

	# Linksonder
	draw_line(Vector2(0, h), Vector2(corner_length, h), color, thickness)
	draw_line(Vector2(0, h), Vector2(0, h - corner_length), color, thickness)

	# Rechtsonder
	draw_line(Vector2(w, h), Vector2(w - corner_length, h), color, thickness)
	draw_line(Vector2(w, h), Vector2(w, h - corner_length), color, thickness)
