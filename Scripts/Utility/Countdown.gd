extends Node

@onready var label = $Label
@onready var timer = $Timer

func _ready() -> void:
	timer.start()

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var sec = fmod(time_left, 60)
	return [minute, sec]

func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left()
