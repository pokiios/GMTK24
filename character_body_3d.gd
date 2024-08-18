extends CharacterBody3D
class_name Player

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
const RAY_LENGTH = 1000


var mouse_sensitivity = 0.002  # radians/pixel
var throw_power = 0
var mouse_right_down: bool = false


@onready var camera = $Pivot/PlayerCamera
var carrying :RigidBody3D = null
var carry_col

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if mouse_right_down && carrying:
		throw_power += 4 * delta
		clamp(throw_power,0,10)
	$CanvasLayer/MarginContainer/VBoxContainer/ProgressBar	.set_value(throw_power)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if Input.is_action_just_released("right_click") && carrying == null:
		var origin = camera.project_ray_origin(mousepos)
		var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		var the_node := result['collider'] as Node3D
		if the_node:
			if the_node.is_in_group('grabable'):
				carrying = the_node
				
				for child in carrying.get_children():
					var cast_child := child as Area3D
					if cast_child:
						var child_shape := cast_child.get_child(0) as CollisionShape3D
						if child_shape:
							child_shape.disabled = false
							
				var cast_carrying := carrying as Knife
				if cast_carrying:
					carrying.rotation.y = -90
					carrying.rotation.x = -180
					carrying.rotation.z = 90

			
	elif Input.is_action_just_released("right_click") && carrying:
		carrying.freeze = false
		carry_col.disabled = false
		carrying.apply_impulse(-throw_power * transform.basis.z)
		throw_power = 0
		
		for child in carrying.get_children():
			var cast_child := child as Area3D
			if cast_child:
				var child_shape := cast_child.get_child(0) as CollisionShape3D
				if child_shape:
					child_shape.disabled = true
		carrying = null
	
	#if Input.is_action_just_pressed("left_click") && carrying:
	#	carrying.freeze = false
#		carry_col.disabled = false
		
#		carrying.apply_impulse(-10 * transform.basis.z)
#		carrying = null
		
			
	if carrying:
		carrying.freeze = true
		for child in carrying.get_children():
			if child is CollisionShape3D:
				carry_col = child
		carry_col.disabled = true
		
		carrying.position = $Pivot/Hands.global_position
		carrying.rotation = $Pivot/Hands.global_rotation

	

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

	if event is InputEventMouseButton:
		if event.button_index == 2 and event.is_pressed():
			mouse_right_down = true
		elif event.button_index == 2 and event.is_released():
			mouse_right_down = false
			
