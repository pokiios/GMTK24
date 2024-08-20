extends Area3D
class_name WinZone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var Plate := body as plate
	if Plate:
		if Plate.is_pie:
			#,make scene change here
			pass
		
	pass # Replace with function body.
