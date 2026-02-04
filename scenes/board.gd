extends NinePatchRect
class_name Board

var tile_pck:PackedScene = preload("res://scenes/tile.tscn")



func generate(gridsize:Vector2i, empties:Array[Vector2i]) -> void:
	var tile_size:Vector2 = Vector2(size.x/gridsize.x, size.y/gridsize.y)
	
	for child in get_children():
		child.queue_free()
	
	var index:int = 0
	for x in range(gridsize.x):
		for y in range(gridsize.y):
			if Vector2i(x,y) in empties:
				continue
			var inst:Tile = tile_pck.instantiate()
			inst.tileindex = index
			inst.set_tilesize(tile_size)
			inst.position.x = x*tile_size.x
			inst.position.y = y*tile_size.y
			add_child(inst)
			index += 1

func get_hole(tileindex:int, holeindex:int) -> Hole:
	return get_child(tileindex).holes.get_child(holeindex)

func set_tiles_state(to:int) -> void:
	for t:Tile in get_children():
		t.state = to
