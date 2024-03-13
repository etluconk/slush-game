extends Node

var p_slurping = false
var p_alive = true
var p_inside_monster = false

var stopwatch = 0
const STOPWATCH_MAX = 15

var l_btn_str = "A"
var r_btn_str = "D"
var j_btn_str = "W"

var p_pos = Vector2.ZERO
var p_has_flippity = false

var lev = 1

signal flippity_floppity
signal monochrome_animation

signal reset_lev

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if p_has_flippity:
		stopwatch += delta

		if stopwatch > STOPWATCH_MAX:
			flippity_floppity_the_controls()
			stopwatch = 0

# This code is absolute garbaj but whatever :|
func char_to_key(character: String):
	var uppercase_character = character.to_upper()

	# I hate this I hate this
	match uppercase_character:
		"A":
			return KEY_A
		"B":
			return KEY_B
		"C":
			return KEY_C
		"D":
			return KEY_D
		"E":
			return KEY_E
		"F":
			return KEY_F
		"G":
			return KEY_G
		"H":
			return KEY_H
		"I":
			return KEY_I
		"J":
			return KEY_J
		"K":
			return KEY_K
		"L":
			return KEY_L
		"M":
			return KEY_M
		"N":
			return KEY_N
		"O":
			return KEY_O
		"P":
			return KEY_P
		"Q":
			return KEY_Q
		"R":
			return KEY_R
		"S":
			return KEY_S
		"T":
			return KEY_T
		"U":
			return KEY_U
		"V":
			return KEY_V
		"W":
			return KEY_W
		"X":
			return KEY_X
		"Y":
			return KEY_Y
		"Z":
			return KEY_Z

	return -1

func get_random_index(array_to_choose_from: Array) -> int:
	return randi() % array_to_choose_from.size()

# :)
func flippity_floppity_the_controls():
	# Just make sure no weird input stuff happens while we're changing the buttons:
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")

	# Now for the fun stuff



	var uppercase_alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

	InputMap.action_erase_events("left")
	InputMap.action_erase_events("right")
	InputMap.action_erase_events("jump")

	for i in 3:
		var rand_key_str = uppercase_alphabet[get_random_index(uppercase_alphabet)]
		var new_key = InputEventKey.new()
		new_key.keycode = char_to_key(rand_key_str)

		# Make sure only one action per button
		uppercase_alphabet.erase(rand_key_str)

		match i:
			0:
				l_btn_str = rand_key_str
				InputMap.action_add_event("left", new_key)
			1:
				r_btn_str = rand_key_str
				InputMap.action_add_event("right", new_key)
			2:
				j_btn_str = rand_key_str
				InputMap.action_add_event("jump", new_key)

	flippity_floppity.emit()

