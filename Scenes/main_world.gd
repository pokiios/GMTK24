extends Node3D

var task_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set task counter to 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#switch statement for tasks
	#for each task, set the correct task text on screen
	# and have an if statement to check if theyve been complete
	# in which case increase task number by 1
	#final task will send to game won screen
	
	match(task_num):
		0:
			#chop potatoes
			pass
		1:
			#fill pot with water
			pass
		2:
			#boil potato chunks
			pass
		3:
			#empty water from pot
			pass
		4:
			#mash potatoes
			pass
		5:
			#chop fish from fridge
			pass
		6:
			#Put mash and fish in oven and bake
			pass
		7:
			#plate and serve pie
			pass
	pass
