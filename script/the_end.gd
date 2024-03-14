extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_good_button_pressed():
	global.lev = 1
	global.p_alive = true
	global.p_has_flippity = false
	global.p_inside_monster = false

	global_music.title_music_again()

	get_tree().change_scene_to_file("res://scene/title_screen.tscn")
