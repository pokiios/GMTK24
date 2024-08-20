extends Node3D
class_name Oven

var is_next_to_handle : bool = false
var is_next_to_knob : bool =  false
var stove_is_on : bool = false
var oven_is_open : bool = false

signal oven_interaction

var stove
var oven_open
var oven_close

func _ready() -> void:
	stove = preload("res://Assets/SFX/stove.wav")
	oven_open = preload("res://Assets/SFX/oven_open.wav")
	oven_close = preload("res://Assets/SFX/oven_door.wav")
	$StoveArea/StoveLight.light_energy = 0
	oven_interaction.connect(_move_oven_door)

func _process(delta: float) -> void:
	$StoveArea/StoveLight.light_energy = stove_is_on

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_next_to_knob:
			stove_is_on = !stove_is_on
			if stove_is_on:
				_play_sound("stove")
			if !stove_is_on:
				$AudioStreamPlayer3D.stop()
		if is_next_to_handle:
			oven_is_open = !oven_is_open
			oven_interaction.emit()

func _on_handle_area_body_entered(body: Node3D) -> void:
	if body is Player:
		is_next_to_handle = true
		body.interact_label.visible = true

func _on_handle_area_body_exited(body: Node3D) -> void:
	if body is Player:
		is_next_to_handle = false
		body.interact_label.visible = false

func _on_knob_area_body_entered(body: Node3D) -> void:
	if body is Player:
		body.interact_label.visible = true

func _on_knob_area_body_exited(body: Node3D) -> void:
	if body is Player:
		body.interact_label.visible = false

func _move_oven_door():
	if oven_is_open:
		_play_sound("oven_open")
		$Oven_001.rotate_x(45)
	elif !oven_is_open:
		$Oven_001.rotate_x(-45)
		_play_sound("oven_close")

func _play_sound(name: String):
	match(name):
		"oven_open":
			$AudioStreamPlayer3D.stream = oven_open
		"oven_close":
			$AudioStreamPlayer3D.stream = oven_close
		"stove":
			$AudioStreamPlayer3D.stream = stove
	$AudioStreamPlayer3D.play()
