extends Node2D

var story = [
	"dave loves the suspiciously cheap
	strawberry slushy from the mall, it's his favorite
	drink!",
	"he is practically addicted to it, which
	is unfortunate because it turns out these sus
	slushies have magic mushrooms in them. uh oh...",
	"On his third of the day, this particular slushy
	was the last 'straw' for his body, and he is having
	a psychedelic trip. Have fun."
]

var story_step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Story.text = story[story_step]
	$AnimatedSprite2D.play(str(story_step))

func _on_change_timer_timeout():
	global.reset_lev.emit()
	global.p_has_flippity = true

func _on_next_pressed():
	if story_step == 2:
		if global_music.title_music:
			global_music.switch_music()
			$AnimatedSprite2D.hide()
			$Story.hide()
			$Next.hide()
			$NextSound.play()

			$ReadyOrNot.show()
			$ReadyButtons.show()
			$ReadyButtons/Yess.grab_focus()

	else:
		story_step += 1
		$NextSound.play()

func _on_yess_pressed():
	$ChangeTimer.start()
	hide()

func _on_noooo_pressed():
	get_tree().quit()
