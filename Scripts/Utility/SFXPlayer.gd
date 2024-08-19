extends AudioStreamPlayer

var hover
var click
var chopping
var oven_open
var oven_close
var fridge_open
var fridge_close
var squish
var stove
var tap_running
var ding
var boing
var pour

func _ready() -> void:
	hover = preload("res://Assets/SFX/button_hover.wav")
	click = preload("res://Assets/SFX/button_click.wav")
	chopping = preload("res://Assets/SFX/chopping.wav")
	oven_open = preload("res://Assets/SFX/oven_open.wav")
	oven_close = preload("res://Assets/SFX/oven_door.wav")
	fridge_open = preload("res://Assets/SFX/fridge_open.wav")
	fridge_close = preload("res://Assets/SFX/fridge_close.wav")
	squish = preload("res://Assets/SFX/squish.wav")
	stove = preload("res://Assets/SFX/stove.wav")
	tap_running = preload("res://Assets/SFX/tap_running.wav")
	ding = preload("res://Assets/SFX/timer_ding.wav")
	boing = preload("res://Assets/SFX/tong_boing.wav")
	pour = preload("res://Assets/SFX/water_pour.wav")
	

func _play_sound(name:String):
	match(name):
		"button_hover":
			stream = hover
		"button_click":
			stream = click
		"chopping":
			stream = chopping
		"oven_open":
			stream = oven_open
		"oven_close":
			stream = oven_close
		"fridge_open":
			stream = fridge_open
		"fridge_close":
			stream = fridge_close
		"squish":
			stream = squish
		"stove":
			stream = stove
		"tap_running":
			stream = tap_running
		"ding":
			stream = ding
		"boing":
			stream = boing
		"pour":
			stream = pour
	play()
