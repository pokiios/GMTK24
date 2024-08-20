extends Area3D
class_name WinZone

var win_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	win_scene = preload("res://Scenes/Levels/win_menu.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var Plate := body as plate
	if Plate:
		if Plate.is_pie:
			#,make scene change here
			MusicPlayer._transition_out()
			await
			get_tree().change_scene_to_packed(win_scene)
			pass
		
	pass # Replace with function body.
