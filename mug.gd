extends Node3D
class_name Mug

var valid_to_fill = false
var is_full = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && valid_to_fill && !is_full:
			is_full = true
	elif Input.is_action_just_pressed("interact") && valid_to_fill && is_full:
			is_full = false
	 # Replace with function body.
	if is_full:
		$CollisionShape3D/Water.visible = true
	else:
		$CollisionShape3D/Water.visible = false

	pass

func _on_area_3d_area_entered(area):
	var body = area.get_parent()
	var pot := body as Pot#Glass
	if pot:
		valid_to_fill = true
		#if glass.full = true
	 # Replace with function body.


func _on_area_3d_area_exited(area):
	var body = area.get_parent()
	var pot := body as Pot#Glass
	if pot:
		valid_to_fill = false
	 # Replace with function body.
