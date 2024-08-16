extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RAY_LENGTH = 1000


var mouse_sensitivity = 0.002  # radians/pixel


@onready var camera = $Pivot/PlayerCamera
var carrying :RigidBody3D = null
#var joint

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	
	

	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("right_click") && carrying == null:
		var origin = camera.project_ray_origin(mousepos)
		var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		var the_node := result['collider'] as RigidBody3D
		if the_node.is_in_group('grabable'):
			carrying = the_node
			
	elif Input.is_action_just_pressed("right_click") && carrying:
		carrying.freeze = false
		var carry_col := carrying.get_child(0) as CollisionShape3D
		carry_col.disabled = false
		carrying = null
		
			
	if carrying:
		
		carrying.freeze = true
		var carry_col := carrying.get_child(0) as CollisionShape3D
		carry_col.disabled = true
		
		carrying.position = $Pivot/Hands.global_position
		carrying.rotation = $Pivot/Hands.global_rotation


		
		 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
