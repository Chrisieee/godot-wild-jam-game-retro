extends Node3D

@onready var areaSize := ($spawnArea.mesh as PlaneMesh).size
@onready var treeMM := $treeMultiMesh
@onready var bushMM := $bushMultiMesh
@onready var player = get_tree().current_scene.get_node("player")

@export var treeMesh: Mesh
@export var treeScene: PackedScene
@export var amount: int = 300
@export var bushMesh: Mesh
@export var bushScene: PackedScene
@export var bushAmount: int = 50
@export var minDistance: float = 10.0
@export var bushMinDistance: float = 10.0

var rng := RandomNumberGenerator.new()
var treePositions: Array[Vector3] = []
var bushPositions: Array[Vector3] = []

class SpawnData:
	var transform: Transform3D
	var active := false
	var node: Node3D = null

var trees: Array[SpawnData] = []
var bushes: Array[SpawnData] = []
var activeDistance := 40.0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	
	var treeMultiMesh := MultiMesh.new()
	treeMultiMesh.transform_format = MultiMesh.TRANSFORM_3D
	treeMultiMesh.mesh = treeMesh
	treeMM.multimesh = treeMultiMesh

	var bushMultiMesh := MultiMesh.new()
	bushMultiMesh.transform_format = MultiMesh.TRANSFORM_3D
	bushMultiMesh.mesh = bushMesh
	bushMM.multimesh = bushMultiMesh

	_generate()

func _generate():
	for i in range(amount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if _is_valid_position(pos, treePositions, minDistance):
			var rotation = rng.randf() * TAU
			var scale = rng.randf_range(1.0, 2.0)

			var basis := Basis()
			basis = basis.rotated(Vector3.UP, rotation)
			basis = basis.scaled(Vector3.ONE * scale)

			var data = SpawnData.new()
			data.transform = Transform3D(basis, pos)

			trees.append(data)
			treePositions.append(pos)

	for i in range(bushAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if _is_valid_bush_position(pos):
			var data = SpawnData.new()
			var rotation1 = rng.randf() * TAU
			var scale1 = rng.randf_range(0.7, 1.3)

			var basis1 := Basis()
			basis1 = basis.rotated(Vector3.UP, rotation1)
			basis1 = basis.scaled(Vector3.ONE * scale1)
			data.transform = Transform3D(basis1, pos)

			bushes.append(data)
			bushPositions.append(pos)
	
	_fill_multimesh(treeMM.multimesh, trees)
	_fill_multimesh(bushMM.multimesh, bushes)

func _is_valid_position(pos: Vector3, positions: Array[Vector3], min_distance: float) -> bool:
	for other in positions:
		if pos.distance_to(other) < min_distance:
			return false

	return true

func _is_valid_bush_position(pos: Vector3) -> bool:
	for other in bushPositions:
		if pos.distance_to(other) < bushMinDistance:
			return false

	for other in treePositions:
		if pos.distance_to(other) < 2.0:
			return false

	return true

func _fill_multimesh(mm: MultiMesh, data: Array[SpawnData]):
	mm.instance_count = data.size()

	for i in range(data.size()):
		mm.set_instance_transform(i, data[i].transform)

func _on_timer_timeout():
	_update_active_objects()
	
func _update_active_objects():
	for tree in trees:
		var world_transform = global_transform * tree.transform
		var distance = player.global_position.distance_to(world_transform.origin)

		if distance < activeDistance:
			if tree.node == null:
				var new_tree = treeScene.instantiate()
				
				$activeObjects.add_child(new_tree)
				
				new_tree.transform = tree.transform

				tree.node = new_tree
		else:
			if tree.node != null:
				tree.node.queue_free()
				tree.node = null
	
	for bush in bushes:
		var world_transform = global_transform * bush.transform
		var distance = player.global_position.distance_to(world_transform.origin)

		if distance < activeDistance:
			if bush.node == null:
				var new_bush = bushScene.instantiate()
				
				$activeObjects.add_child(new_bush)
				
				new_bush.transform = bush.transform

				bush.node = new_bush
		else:
			if bush.node != null:
				bush.node.queue_free()
				bush.node = null
