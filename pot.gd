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
var player : Player

var is_water_boiling : bool = false
var is_water_poured : bool = false
@export var chunk_scene : PackedScene
@export var mash_scene : PackedScene

signal boil_complete
signal mash_complete

var pour
var boiled
# Called when the node enters the scene tree for the first time.
func _ready():
	$SteamParticles.emitting = false
	pour = preload("res://Assets/SFX/water_pour.wav")
	boiled = preload("res://Assets/SFX/boiling_water.wav")
	for child in self.get_parent().get_children():
		if child is Oven:
			oven = child
	for child in self.get_parent().get_parent().get_children():
		if child is Player:
			player = child
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && valid_to_fill && !is_full:
			$Water.visible = true
			_play_sound("pour")
			is_full = true
	elif Input.is_action_just_pressed("interact") && valid_to_fill && is_full:
			$Water.visible = false
			is_full = false
			
	if oven:		
		if oven.stove_is_on && is_full:
			is_boiling = true
			$SteamParticles.emitting = true
			_play_sound("boil")
			#need steam particles
		else: 
			is_boiling = false
			$SteamParticles.emitting = false
	
	if is_boiling && has_food.size() >= 2:
		is_boiling = false
		await get_tree().create_timer(1.0).timeout
		boil_complete.emit()
		$AudioStreamPlayer3D.stop()
		food_boiled = true
	
	if food_boiled && has_food.size() >= 2 && !is_full:
		if player_in_pot && player.just_jumped && mash_count < 2:
			var length = has_food.size()
			for each in length:
				var temp = chunk_scene.instantiate()
				self.get_parent().add_child(temp)
				temp.position = has_food.front().position
				has_food.push_back(temp)
			for each in has_food:
				var chunk := each as PotatoChunk
				#chunk.set_size
			mash_count += 1	
			player.just_jumped = false
		elif player_in_pot && player.just_jumped && mash_count >= 2:
			#spawn mash
			var length = has_food.size()
			for each in length:
				has_food[0].call_deferred("free")
				has_food.remove_at(0)
			var mash = mash_scene.instantiate()
			self.get_parent().get_parent().add_child(mash)
			mash.global_position = $Area3D2.global_position
			mash_complete.emit()
			food_boiled = false
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
		var temp_player = get_tree().get_first_node_in_group("Player")
		temp_player.interact_label.visible = true
		#if glass.full = true
	pass # Replace with function body.


func _on_area_3d_area_exited(area):
	var body = area.get_parent()
	var glass := body as RigidBody3D #Glass
	if glass:
		valid_to_fill = false
		var temp_player = get_tree().get_first_node_in_group("Player")
		temp_player.interact_label.visible = false
	pass # Replace with function body.


func _on_area_3d_2_body_entered(body):
	if body is PotatoChunk:
		if has_food.find(body) == -1:
			has_food.push_back(body)
	elif body is Player:
		player_in_pot = true
	pass # Replace with function body.


func _on_area_3d_2_body_exited(body):
	if body is PotatoChunk:
		for each in len(has_food):
			if has_food[each-1] == body:
				has_food.remove_at(each-1)
	elif body is Player:
		player_in_pot = false
	pass # Replace with function body.

func _play_sound(name: String):
	match(name):
		"pour":
			$AudioStreamPlayer3D.stream = pour
		"boil":
			$AudioStreamPlayer3D.stream = boiled
	$AudioStreamPlayer3D.play()
	
