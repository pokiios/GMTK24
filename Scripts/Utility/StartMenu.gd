extends CanvasLayer

@onready var game_scene
@onready var settings_scene

var hover
var click

func _ready() -> void:
	hover = preload("res://Assets/SFX/button_hover.wav")
	click = preload("res://Assets/SFX/button_click.wav")
	MusicPlayer._play_song("start_menu")
	if MusicPlayer.volume_db <= -10:
		MusicPlayer._transition_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	game_scene = load("res://Scenes/main_world.tscn")
	settings_scene = load("res://Scenes/Menu/Settings.tscn")

func _on_start_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().change_scene_to_packed(game_scene)


func _on_settings_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_packed(settings_scene)


func _on_quit_pressed() -> void:
	_play_sound("click")
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().quit()

func _on_start_mouse_entered() -> void:
	_play_sound("hover")


func _on_settings_mouse_entered() -> void:
	_play_sound("hover")

func _on_quit_mouse_entered() -> void:
	_play_sound("hover")

func _play_sound(name:String):
	match(name):
		"hover":
			$AudioStreamPlayer.stream = hover
		"click":
			$AudioStreamPlayer.stream = click
	$AudioStreamPlayer.play()
