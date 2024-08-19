extends Node3D

var next_to_top_handle : bool = false
var next_to_bottom_handle : bool = false

var top_door_open : bool = false
var bottom_door_open : bool = false

signal top_door_interaction
signal bottom_door_interaction

func _ready():
	top_door_interaction.connect(_move_top_door)
	bottom_door_interaction.connect(_move_bottom_door)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if next_to_top_handle:
			top_door_open = !top_door_open
			top_door_interaction.emit()
		if next_to_bottom_handle:
			bottom_door_open = !bottom_door_open
			bottom_door_interaction.emit()

func _move_top_door():
	if top_door_open:
		SfxPlayer._play_sound("fridge_open")
		$TopPivot.rotate_y(30)
	elif !top_door_open:
		SfxPlayer._play_sound("fridge_close")
		$TopPivot.rotate_y(-30)

func _move_bottom_door():
	if bottom_door_open:
		SfxPlayer._play_sound("fridge_open")
		$BottomPivot.rotate_y(30)
	elif !bottom_door_open:
		SfxPlayer._play_sound("fridge_close")
		$BottomPivot.rotate_y(-30)

func _on_top_handle_area_body_entered(body: Node3D) -> void:
	if body is Player:
		next_to_top_handle = true

func _on_top_handle_area_body_exited(body: Node3D) -> void:
	next_to_top_handle = false

func _on_bottom_handle_area_body_entered(body: Node3D) -> void:
	if body is Player:
		next_to_bottom_handle = true

func _on_bottom_handle_area_body_exited(body: Node3D) -> void:
	next_to_bottom_handle = false
