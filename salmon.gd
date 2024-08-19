extends Node3D
class_name Salmon

@export var chunk_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_area_entered(area):
	var body = area.get_parent()
	var knife := body as Knife#Glass
	if knife:
		for i in 8:
			var chunk = chunk_scene.instantiate()
			self.get_parent().add_child(chunk)
			chunk.global_position = Vector3(self.global_position.x ,self.global_position.y+ randf_range(0.1, 0.5),self.global_position.z)
			
			self.call_deferred("free")
	
