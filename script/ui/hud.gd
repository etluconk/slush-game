extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$FlippityFloppityTimer.max_value = global.STOPWATCH_MAX - 5

	$Keys/Left/Label.text = global.l_btn_str
	$Keys/Right/Label.text = global.r_btn_str
	$Keys/Jump/Label.text = global.j_btn_str

	global.flippity_floppity.connect(flippy)
	global.reset_lev.connect(transition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.p_has_flippity:
		$FlippityFloppityTimer.value = global.STOPWATCH_MAX - global.stopwatch

		if global.STOPWATCH_MAX - global.stopwatch < 1.5 and !$Alert.is_playing():
			$Alert.play()

	$FlippityFloppityTimer.visible = global.p_has_flippity
	if get_tree().current_scene != null:
		var scene_name = get_tree().current_scene.name
		visible = not(scene_name == "TitleScreen" or scene_name == "BeginningCutscene")

	if global.p_inside_monster:
		hide()

func flippy():
	$Keys/Left/Label.text = global.l_btn_str
	$Keys/Right/Label.text = global.r_btn_str
	$Keys/Jump/Label.text = global.j_btn_str

	$AnimationPlayer.play("change")
	$ChangeSound.play()

func transition():
	$"../Transition/AnimationPlayer".play("transition")
	$"../Transition/ResetTimer".start()

func next_lev():
	global.p_slurping = false
	global.p_alive = true
	get_tree().change_scene_to_file("res://scene/Lev/" + str(global.lev) + ".tscn")

	if global.lev == 15:
		global_music.stop()
