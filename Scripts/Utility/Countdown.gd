extends Node

@onready var label = $Label
@onready var timer = $Timer
@onready var game_over_scene

func _ready() -> void:
	game_over_scene = preload("res://Scenes/Menu/game_over.tscn")
	timer.start()

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var sec = fmod(time_left, 60)
	return [minute, sec]

func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left()

func _on_timer_timeout() -> void:
	timer.stop()
	get_tree().change_scene_to_packed(game_over_scene)
