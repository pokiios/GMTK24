extends Node3D
class_name Pot

var valid_to_fill = false
var is_full = false
var is_boiling = false
var food_boiled = false
var player_in_pot = false
var mash_count = 0
var has_food : Array
var oven : Oven
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_parent().get_children():
		if child is Oven:
			oven = child
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && valid_to_fill && !is_full:
			$Water.visible = true
			is_full = true
	elif Input.is_action_just_pressed("interact") && valid_to_fill && is_full:
			$Water.visible = false
			is_full = false
			
	if oven:		
		if oven.stove_is_on && is_full:
			is_boiling = true
			#need steam particles
		else: 
			is_boiling = false
	
	if is_boiling && has_food.size() >= 2:
		is_boiling = false
		await get_tree().create_timer(1.0).timeout
		print("potatoes are boiled")
		
		food_boiled = true
	
	if food_boiled && has_food.size() == 2 && !is_full:
		if player_in_pot && Input.is_action_just_pressed("jump") && mash_count < 2:
			for each in has_food:
				var temp = PotatoChunk.new()
				self.get_parent().add_child(temp)
				has_food.push_back(temp)
			for each in has_food:
				var chunk := each as PotatoChunk
				chunk.scale /= 2
			mash_count += 1	
		elif player_in_pot && Input.is_action_just_pressed("jump") && mash_count >= 2:
			#spawn mash
			pass
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


func _on_area_3d_2_body_entered(body):
	if body is PotatoChunk:
		has_food.push_back(body)
	elif body is Player:
		player_in_pot = true
	pass # Replace with function body.


func _on_area_3d_2_body_exited(body):
	if body is PotatoChunk:
		for each in len(has_food):
			if has_food[each] == body:
				has_food.remove_at(each)
	elif body is Player:
		player_in_pot = false
	pass # Replace with function body.
