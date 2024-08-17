extends RigidBody3D
class_name PotatoChunk


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area):
	var body = area.get_parent()

	var pot := body as Pot#Glass
	if pot:
		if pot.is_full:
			pass #do boiling here
	pass # Replace with function body.
