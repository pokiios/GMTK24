extends Node3D
class_name Pot

var valid_to_fill = false
var is_full = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && valid_to_fill && !is_full:
			$Water.visible = true
			is_full = true
	elif Input.is_action_just_pressed("interact") && valid_to_fill && is_full:
			$Water.visible = false
			is_full = false
	pass


func _on_area_3d_body_entered(body):

		
	pass # Replace with function body.


func _on_area_3d_body_exited(body):

	pass # Replace with function body.


func _on_area_3d_area_entered(area):
	var body = area.get_parent()
	var glass := body as RigidBody3D #Glass
	if glass:
		valid_to_fill = true
		#if glass.full = true
	pass # Replace with function body.


func _on_area_3d_area_exited(area):
	var body = area.get_parent()
	var glass := body as RigidBody3D #Glass
	if glass:
		valid_to_fill = false
	pass # Replace with function body.
