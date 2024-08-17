class_name Sink
extends Node3D

var glass = null

var player_next_to_tap : bool = false
var tap_is_on : bool = false

signal glass_interaction

func _ready():
	glass_interaction.connect(_fill_glass)
	$Water.visible = tap_is_on
	pass

func _process(delta: float) -> void:
	$Water.visible = tap_is_on

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_next_to_tap:
			tap_is_on = !tap_is_on

# If in the tap area and it's interacted with, turn tap on
func _on_tap_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player_next_to_tap = true
			
func _on_tap_area_body_exited(body: Node3D) -> void:
	player_next_to_tap = false

func _on_glass_area_body_entered(body: Node3D) -> void:
	#if body is Glass && tap_is_on:
		#if body.glass_full == false:
			#glass_interaction.emit()
	pass

func _fill_glass():
	#The code here would set the water to visible i suppose? Not to sure how the filling works
	pass
