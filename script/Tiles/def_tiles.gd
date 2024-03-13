extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.p_has_flippity and get_node_or_null("Slushy") != null:
		#$Slushy.queue_free()
		pass

func remove_goo():
	var used_tiles = get_used_cells(0)

	for i in used_tiles.size():
		if get_cell_tile_data(0, used_tiles[i]).terrain == 1:
			erase_cell(0, used_tiles[i])

