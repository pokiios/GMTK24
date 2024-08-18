extends CanvasLayer

@onready var start_scene

func _ready() -> void:
	start_scene = load("res://Scenes/Menu/start_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)
