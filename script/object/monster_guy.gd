extends Area2D

@export var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Head/Black1.look_at(target.position)
	$Head/Black2.look_at(target.position)
