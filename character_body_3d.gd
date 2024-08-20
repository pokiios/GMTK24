extends CharacterBody3D
class_name Player

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
const RAY_LENGTH = 1000


var mouse_sensitivity = 0.002  # radians/pixel
var throw_power = 0
var mouse_right_down: bool = false
var just_jumped : bool = false
var jump_timer : Timer
var mouse_toggle : bool = false


@onready var camera = $Pivot/PlayerCamera
var carrying :RigidBody3D = null
var carry_col

var pot : Pot
var oven_dish : ovenDish

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	jump_timer = Timer.new()
	add_child(jump_timer)
	jump_timer.timeout.connect(_on_jump_timeout)

func _ready():
	for child in self.get_parent().get_children():
		if child is Pot:
			pot = child
		elif child is ovenDish:
			oven_dish = child
			
	pot.boil_complete.connect(_on_boiled)
	pot.mash_complete.connect(_on_mashed)
	oven_dish.bake_completed.connect(_on_baked)
	oven_dish.plate_completed.connect(_on_plated)
	
func _process(delta: float) -> void:
	if mouse_toggle:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif !mouse_toggle:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if mouse_right_down && carrying:
		throw_power += 1 * delta
		clamp(throw_power,0,5)
	$CanvasLayer/MarginContainer/VBoxContainer/ProgressBar.set_value(throw_power)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_timer.start(1.0)
		just_jumped = true
		
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
		query.collide_with_areas = false
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
		carrying.apply_impulse(Vector3(-throw_power * transform.basis.z.x, 0.1*throw_power, -throw_power * transform.basis.z.z))
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
		
		var cast_carrying2 := carrying as plate
		if cast_carrying2:
			carrying.rotation.y = $Pivot/Hands.global_rotation.y
			carrying.rotation.z = $Pivot/Hands.global_rotation.z
		else:
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
	if Input.is_action_just_pressed("mouse_toggle"):
		mouse_toggle = !mouse_toggle

func _on_jump_timeout():
	just_jumped = false
	
func _on_boiled():
	$CanvasLayer/MarginContainer2/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel.set_text("[s]boil at least 2 potatoes[/s]")

func _on_mashed():
	$CanvasLayer/MarginContainer2/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel4.set_text("[s]drain and mash the potatoes[/s]")
	
func _on_baked():
	$CanvasLayer/MarginContainer2/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel2.set_text("[s]put the mash, and at least 4 slices of fish in the oven dish to bake[/s]")
	
func _on_plated():
	$CanvasLayer/MarginContainer2/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel3.set_text("[s]plate up[/s]")	
