extends Node3D

@export var treeScene: PackedScene
@export var amount: int = 300
@export var minDistance: float = 10.0

@onready var areaSize := ($spawnArea.mesh as PlaneMesh).size

var rng := RandomNumberGenerator.new()
var positions: Array[Vector3] = []

func _ready():
	rng.seed = 12345
	generate()

func generate():
	for i in range(amount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if is_valid_position(pos):
			positions.append(pos)

			var tree = treeScene.instantiate()
			tree.position = pos
			tree.rotation.y = rng.randf() * TAU
			var scale = rng.randf_range(1, 2)
			tree.scale = Vector3.ONE * scale
			
			$trees.add_child(tree)

func is_valid_position(pos: Vector3) -> bool:
	for other in positions:
		if pos.distance_to(other) < minDistance:
			return false
	return true
