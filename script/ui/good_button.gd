extends Button

@export var first_focus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if first_focus:
		grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	$Press.play()
