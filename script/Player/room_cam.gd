extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var goal_pos = Vector2(floor(global.p_pos.x / 320) * 320 + (320/2), ceil(global.p_pos.y / 180) * 180 - (180/2))
	position = Vector2(lerpf(position.x, goal_pos.x, 20 * delta), lerpf(position.y, goal_pos.y, 20 * delta))

