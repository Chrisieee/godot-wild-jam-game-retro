extends Node3D
class_name PhotoObject

@export var objectName: String
@export var points: int

func _ready():
	add_to_group("photoObjects")
	add_to_group(objectName)
