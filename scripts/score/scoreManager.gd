extends Node

func calculate_score(photo):
	check_objects(photo)
	
	var score = 0
	
	for object in photo.objects:
		var objectScore = roundi(object.object.points * object.visibility)
		score += objectScore
		
		photo.scoreReasons.append({
			"name": object.object.objectName,
			"points": objectScore
		})
		print(score)
	
	return score


func check_objects(photo):
	var camera = get_tree().current_scene.get_node("player/head/SubViewport/photoCamera")
	var player = get_tree().current_scene.get_node("player")
	var viewportSize = camera.get_viewport().get_visible_rect().size
	var spaceState = camera.get_world_3d().direct_space_state

	for object in get_tree().get_nodes_in_group("photoObjects"):
		if camera.is_position_behind(object.global_position):
			continue
		
		var screenPos = camera.unproject_position(object.global_position)
		
		if !Rect2(Vector2.ZERO, viewportSize).has_point(screenPos):
			continue
		
		var visiblePoints = 0
		var photoPoints = object.get_node("photoPoints").get_children()
		
		for point in photoPoints:
			var query = PhysicsRayQueryParameters3D.create(
				camera.global_position,
				point.global_position
			)
			query.exclude = [camera, player]

			var result = spaceState.intersect_ray(query)
			
			if result and result.collider == object:
				visiblePoints += 1
		
		var visibility = float(visiblePoints) / photoPoints.size()

		if visibility >= 0.5:
			var result = PhotoObjectResult.new()
			result.object = object
			result.visibility = visibility
			
			print(result.object)
			
			photo.objects.append(result)
