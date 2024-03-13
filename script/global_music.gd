extends AudioStreamPlayer

var title_music = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_music():
	play()
	$TitleScreen.stop()
	title_music = false
