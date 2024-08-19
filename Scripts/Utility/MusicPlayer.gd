extends AudioStreamPlayer

var fading_in
var fading_out

var start_menu_music
var game_music

func _ready() -> void:
	game_music = preload("res://Assets/Music/game_music.mp3")
	start_menu_music = preload("res://Assets/Music/start_menu.mp3")
	volume_db = -80
	autoplay = true

func _process(delta : float) -> void:
	if fading_in:
		volume_db += delta * 60
		if volume_db >= -10:
			fading_in = false
	if fading_out:
		volume_db -= delta * 60
		if volume_db <= -80:
			fading_out = false

func _play_song(song_name):
	if song_name == "start_menu":
		stream = start_menu_music
	elif song_name == "game_music":
		stream = game_music
	play()

func _transition_out():
	fading_out = true
	fading_in = false

func _transition_in():
	fading_in = true
	fading_out = false
