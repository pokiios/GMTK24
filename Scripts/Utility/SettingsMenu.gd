extends CanvasLayer

@onready var start_scene

var hover
var click

func _ready() -> void:
	hover = preload("res://Assets/SFX/button_hover.wav")
	click = preload("res://Assets/SFX/button_click.wav")
	start_scene = load("res://Scenes/Menu/start_menu.tscn")

func _on_back_button_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_packed(start_scene)

func _on_back_button_mouse_entered() -> void:
	_play_sound("hover")

func _play_sound(name:String):
	match(name):
		"hover":
			$AudioStreamPlayer.stream = hover
		"click":
			$AudioStreamPlayer.stream = click
	$AudioStreamPlayer.play()
