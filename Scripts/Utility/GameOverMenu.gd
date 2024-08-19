extends CanvasLayer

@onready var start_menu
@onready var game_scene

var hover
var click

func _ready() -> void:
	hover = preload("res://Assets/SFX/button_hover.wav")
	click = preload("res://Assets/SFX/button_click.wav")
	MusicPlayer._play_song("start_menu")
	MusicPlayer._transition_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	start_menu = preload("res://Scenes/Menu/start_menu.tscn")
	game_scene = preload("res://Scenes/main_world.tscn")

func _on_retry_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().change_scene_to_packed(game_scene)


func _on_main_menu_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().change_scene_to_packed(start_menu)

func _on_quit_pressed() -> void:
	_play_sound("click")
	await $AudioStreamPlayer.finished
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().quit()

func _on_retry_mouse_entered() -> void:
	_play_sound("hover")


func _on_main_menu_mouse_entered() -> void:
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
