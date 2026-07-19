extends Node3D

@export var foxScene: PackedScene
@export var foxAmount: int = 1
@export var birdScene: PackedScene
@export var birdAmount: int = 50
@export var minDistance: float = 20.0

@onready var areaSize := ($spawnArea.mesh as PlaneMesh).size

var rng := RandomNumberGenerator.new()
var foxPositions: Array[Vector3] = []
var birdPositions: Array[Vector3] = []

func _ready():
	#rng.seed = 12345
	_generate()

func _generate():
	for i in range(foxAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if _is_valid_position(pos):
			foxPositions.append(pos)
			_spawn_object(foxScene, $animals, 1, 1.1, pos)
	
	for i in range(birdAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if _is_valid_position(pos):
			birdPositions.append(pos)
			_spawn_object(birdScene, $animals, 1, 1.1, pos)

func _spawn_object(scene: PackedScene, parent: Node, scale_min: float, scale_max: float, pos):
	var obj = scene.instantiate()

	obj.position = pos
	obj.rotation.y = rng.randf() * TAU

	var scale = rng.randf_range(scale_min, scale_max)
	obj.scale = Vector3.ONE * scale

	parent.add_child(obj)

func _is_valid_position(pos: Vector3) -> bool:
	for other in birdPositions:
		if pos.distance_to(other) < minDistance:
			return false
	
	for other in foxPositions:
		if pos.distance_to(other) < minDistance:
			return false
	
	var objects = get_tree().get_nodes_in_group("photoObjects")
	for object in objects:
		if pos.distance_to(object.position) < 25:
			return false
	
	return true
