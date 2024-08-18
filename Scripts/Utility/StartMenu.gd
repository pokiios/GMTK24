extends CanvasLayer

@onready var game_scene
@onready var settings_scene

func _ready() -> void:
	game_scene = load("res://Scenes/main_world.tscn")
	settings_scene = load("res://Scenes/Settings.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_packed(settings_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
