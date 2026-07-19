extends Node3D

@onready var areaSize := ($spawnArea.mesh as PlaneMesh).size
@onready var foxMM := $foxMultiMesh
@onready var birdMM := $birdMultiMesh
@onready var player = get_tree().current_scene.get_node("player")

@export var foxScene: PackedScene
@export var foxMesh: Mesh
@export var foxAmount: int = 1
@export var birdScene: PackedScene
@export var birdMesh: Mesh
@export var birdAmount: int = 50
@export var minDistance: float = 20.0

var rng := RandomNumberGenerator.new()
var foxPositions: Array[Vector3] = []
var birdPositions: Array[Vector3] = []

class SpawnData:
	var transform: Transform3D
	var active := false
	var node: Node3D = null

var foxes: Array[SpawnData] = []
var birds: Array[SpawnData] = []
var activeDistance := 20.0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)

	var foxesMultiMesh := MultiMesh.new()
	foxesMultiMesh.transform_format = MultiMesh.TRANSFORM_3D
	foxesMultiMesh.mesh = foxMesh
	foxMM.multimesh = foxesMultiMesh

	var birdMultiMesh := MultiMesh.new()
	birdMultiMesh.transform_format = MultiMesh.TRANSFORM_3D
	birdMultiMesh.mesh = birdMesh
	birdMM.multimesh = birdMultiMesh
	
	_generate()

func _generate():
	for i in range(foxAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))

		if _is_valid_position(pos):
			var rotation = rng.randf() * TAU
			var scale = rng.randf_range(0.3, 0.35)

			var basis := Basis()
			basis = basis.rotated(Vector3.UP, rotation)
			basis = basis.scaled(Vector3.ONE * scale)

			var data = SpawnData.new()
			data.transform = Transform3D(basis, pos)
			
			foxes.append(data)
			foxPositions.append(pos)
	
	for i in range(birdAmount):
		var pos = Vector3(rng.randf_range(-areaSize.x/2, areaSize.x/2),0,rng.randf_range(-areaSize.y/2, areaSize.y/2))
		
		if _is_valid_position(pos):
			var rotation1 = rng.randf() * TAU
			var scale1 = rng.randf_range(0.1, 0.15)

			var basis1 := Basis()
			basis1 = basis1.rotated(Vector3.UP, rotation1)
			basis1 = basis1.scaled(Vector3.ONE * scale1)

			var data = SpawnData.new()
			data.transform = Transform3D(basis1, pos)
			
			birds.append(data)
			birdPositions.append(pos)
	
	_fill_multimesh(foxMM.multimesh, foxes)
	_fill_multimesh(birdMM.multimesh, birds)

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

func _fill_multimesh(mm: MultiMesh, data: Array[SpawnData]):
	mm.instance_count = data.size()

	for i in range(data.size()):
		mm.set_instance_transform(i, data[i].transform)

func _on_timer_timeout():
	_update_active_objects()

func _update_active_objects():
	for fox in foxes:
		var world_transform = global_transform * fox.transform
		var distance = player.global_position.distance_to(world_transform.origin)

		if distance < activeDistance:
			if fox.node == null:
				var new_fox = foxScene.instantiate()
				
				$activeAnimals.add_child(new_fox)
				
				new_fox.transform = fox.transform

				fox.node = new_fox
		else:
			if fox.node != null:
				fox.node.queue_free()
				fox.node = null
	
	for bird in birds:
		var world_transform = global_transform * bird.transform
		var distance = player.global_position.distance_to(world_transform.origin)

		if distance < activeDistance:
			if bird.node == null:
				var new_bird = birdScene.instantiate()
				
				$activeAnimals.add_child(new_bird)
				
				new_bird.transform = bird.transform

				bird.node = new_bird
		else:
			if bird.node != null:
				bird.node.queue_free()
				bird.node = null
