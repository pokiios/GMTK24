extends Node3D
class_name ovenDish

var food_cooked = false
var valid_to_plate = false
var needs_moved = true

var has_mash : Array
var has_fish : Array
var oven : Oven
var plate_for_pie : plate


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_parent().get_children():
		if child is Oven:
			oven = child
	for child in self.get_parent().get_children():
		if child is plate:
			plate_for_pie = child
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if oven.oven_is_open && needs_moved:
		global_position.z += 0.3
		needs_moved = false
	if !oven.oven_is_open && !needs_moved:
		global_position.z -= 0.3
		needs_moved = true
	
	if Input.is_action_just_pressed("interact") && valid_to_plate:
			$Pie.visible = false
			plate_for_pie.pie.visible = true
	
	if !oven.oven_is_open && has_mash.size() >=1 && has_fish.size() >= 4:
		food_cooked = true
		var length = has_mash.size()
		for each in length:
				has_mash[0].call_deferred("free")
				has_mash.remove_at(0)
		length = has_fish.size()
		for each in length:
				has_fish[0].call_deferred("free")
				has_fish.remove_at(0)
	
	pass
	if food_cooked:
		$Pie.visible = true

func _on_area_3d_body_entered(body):
	if body is mash:
		if has_mash.find(body) == -1:
			has_mash.push_back(body)
	elif body is Salmon:
		if has_fish.find(body) == -1:
			has_fish.push_back(body)
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body is mash:
		for each in len(has_mash):
			if has_mash[each-1] == body:
				has_mash.remove_at(each-1)
	elif body is Salmon:
		for each in len(has_fish):
			if has_fish[each-1] == body:
				has_fish.remove_at(each-1)
	pass # Replace with function body.


func _on_area_3d_2_area_entered(area):
	var body = area.get_parent()
	var plate := body as RigidBody3D#Plate #Glass
	if plate:
		valid_to_plate = true
	pass # Replace with function body.


func _on_area_3d_2_area_exited(area):
	var body = area.get_parent()
	var plate := body as RigidBody3D#Plate #Glass
	if plate:
		valid_to_plate = false
	pass # Replace with function body.
