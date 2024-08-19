extends CanvasLayer

@onready var start_menu
@onready var game_scene

func _ready() -> void:
	start_menu = preload("res://Scenes/Menu/start_menu.tscn")
	game_scene = get_tree().reload_current_scene()



func _on_retry_pressed() -> void:
	game_scene


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(start_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
