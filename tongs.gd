extends Node3D
class_name Tongs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	var player := body as Player
	if player:
		#if player.velocity.y < 0:
		player.velocity = Vector3(6*transform.basis.z.x,6,6*transform.basis.z.z)
		SfxPlayer._play_sound("boing")
		
	pass # Replace with function body.
