extends CanvasLayer

@onready var start_menu
@onready var game_scene

func _ready() -> void:
	MusicPlayer._play_song("start_menu")
	MusicPlayer._transition_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	start_menu = preload("res://Scenes/Menu/start_menu.tscn")
	game_scene = preload("res://Scenes/main_world.tscn")

func _on_retry_pressed() -> void:
	MusicPlayer._transition_out()
	get_tree().change_scene_to_packed(game_scene)


func _on_main_menu_pressed() -> void:
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().change_scene_to_packed(start_menu)


func _on_quit_pressed() -> void:
	MusicPlayer._transition_out()
	await MusicPlayer.fading_out == false
	get_tree().quit()
