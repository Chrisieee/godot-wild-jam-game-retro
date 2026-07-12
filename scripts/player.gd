extends CharacterBody3D

@onready var head := $head
@onready var camera := $head/Camera3D
@onready var cameraControl := $head/camera

@export var speed = 20

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("right"):
		input_dir.x += 1
	if Input.is_action_pressed("left"):
		input_dir.x -= 1
	if Input.is_action_pressed("back"):
		input_dir.y -= 1
	if Input.is_action_pressed("forward"):
		input_dir.y += 1

	if input_dir.length() > 1:
		input_dir = input_dir.normalized()

	var direction = (
		head.global_transform.basis.x * input_dir.x +
		-head.global_transform.basis.z * input_dir.y
	).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	#camera controls
	if event.is_action_pressed("camera"):
		cameraControl.raise_camera()
	
	if event.is_action_released("camera"):
		cameraControl.lower_camera()
	
	if event.is_action_pressed("photo"):
		if cameraControl.cameraUp:
			cameraControl.make_photo()
