extends Node3D

@export var foxScene: PackedScene
@export var foxAmount: int = 1
@export var birdScene: PackedScene
@export var birdAmount: int = 50
@export var minDistance: float = 20.0

@onready var areaSize := ($spawnArea.mesh as PlaneMesh).size

var rng := RandomNumberGenerator.new()
var positions: Array[Vector3] = []

func _ready():
	#rng.seed = 12345
	generate()

func generate():
	for i in range(foxAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if is_valid_position(pos):
			positions.append(pos)

			var fox = foxScene.instantiate()
			fox.position = pos
			fox.rotation.y = rng.randf() * TAU
			
			$animals.add_child(fox)
	
	for i in range(birdAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if is_valid_position(pos):
			positions.append(pos)

			var bird = birdScene.instantiate()
			bird.position = pos
			bird.rotation.y = rng.randf() * TAU
			
			$animals.add_child(bird)

func is_valid_position(pos: Vector3) -> bool:
	for other in positions:
		if pos.distance_to(other) < minDistance:
			return false
		
	
	var trees = get_tree().get_nodes_in_group("tree")
	for tree in trees:
		if pos.distance_to(tree.position) < minDistance:
			return false
	
	return true
