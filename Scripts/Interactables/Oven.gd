extends Node3D
class_name Oven

var is_next_to_handle : bool = false
var is_next_to_knob : bool =  false
var stove_is_on : bool = false
var oven_is_open : bool = false

signal oven_interaction

func _ready() -> void:
	$StoveArea/StoveLight.light_energy = 0
	oven_interaction.connect(_move_oven_door)

func _process(delta: float) -> void:
	$StoveArea/StoveLight.light_energy = stove_is_on

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_next_to_knob:
			stove_is_on = !stove_is_on
			if stove_is_on:
				SfxPlayer._play_sound("stove")
			if !stove_is_on:
				SfxPlayer.stop()
		if is_next_to_handle:
			oven_is_open = !oven_is_open
			oven_interaction.emit()

func _on_handle_area_body_entered(body: Node3D) -> void:
	if body is Player:
		is_next_to_handle = true

func _on_handle_area_body_exited(body: Node3D) -> void:
	is_next_to_handle = false

func _on_knob_area_body_entered(body: Node3D) -> void:
	if body is Player:
		is_next_to_knob = true

func _on_knob_area_body_exited(body: Node3D) -> void:
	is_next_to_knob = false

func _move_oven_door():
	if oven_is_open:
		SfxPlayer._play_sound("oven_open")
		$Oven_001.rotate_x(45)
	elif !oven_is_open:
		$Oven_001.rotate_x(-45)
		SfxPlayer._play_sound("oven_close")
