extends NinePatchRect
class_name Board

var tile_pck:PackedScene = preload("res://scenes/tile.tscn")


var pseudo_board:Array = []
var gridsize:Vector2i = Vector2i()
var empties:Array[Vector2i] = []

func generate(my_gridsize:Vector2i, my_empties:Array[Vector2i]) -> void:
	gridsize = my_gridsize
	empties = my_empties
	var tile_size:Vector2 = Vector2(size.x/gridsize.x, size.y/gridsize.y)
	
	for child in get_children():
		child.queue_free()
	
	var index:int = 0
	for y in range(gridsize.y):
		for x in range(gridsize.x):
			if Vector2i(x,y) in empties:
				continue
			var inst:Tile = tile_pck.instantiate()
			inst.tileindex = index
			inst.set_tilesize(tile_size)
			inst.position.x = x*tile_size.x
			inst.position.y = y*tile_size.y
			add_child(inst)
			index += 1
	
	pseudo_board.clear()
	for y in range(gridsize.y*2):
		pseudo_board.append([])
		for x in range(gridsize.x*2):
			pseudo_board[y].append(-1)

func get_hole(tileindex:int, holeindex:int) -> Hole:
	return get_child(tileindex).holes.get_child(holeindex)

func set_tiles_state(to:int) -> void:
	for t:Tile in get_children():
		t.state = to


enum Winner {
	NONE=-1,
	P1=0,
	P2=1,
	BOTH=2
}
func get_winner() -> Winner:
	# Clear pseudo board
	for y in range(pseudo_board.size()):
		for x in range(pseudo_board[y].size()):
			pseudo_board[y][x] = -1
	
	# Update pseudo board
	for tile:Tile in get_children():
		var gridpos:Vector2i = Vector2i((tile.position+tile.size*0.5)/tile.size)
		#print(gridpos)
		pseudo_board[gridpos.y*2][gridpos.x*2] = tile.holes.get_child(0).value
		pseudo_board[gridpos.y*2][gridpos.x*2+1] = tile.holes.get_child(1).value
		pseudo_board[gridpos.y*2+1][gridpos.x*2] = tile.holes.get_child(2).value
		pseudo_board[gridpos.y*2+1][gridpos.x*2+1] = tile.holes.get_child(3).value
	
	var winner:Winner = Winner.NONE
	# vec[0] horizontals
	# vec[1] verticals
	# vec[2] diagonal \
	# vec[3] other diagonal /
	for vec in [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(-1,1)]:
		for y in range(pseudo_board.size()-vec.y*3):
			# max()-stuff purely for 2nd diagonal type /
			for x in range(max(-vec.x*3,0), pseudo_board[y].size()- max(vec.x*3,0) ):
				if pseudo_board[y][x] < 0:
					continue
				if pseudo_board[y][x] != pseudo_board[y+vec.y][x+vec.x]:
					continue
				if pseudo_board[y+vec.y][x+vec.x] != pseudo_board[y+2*vec.y][x+2*vec.x]:
					continue
				if pseudo_board[y+2*vec.y][x+2*vec.x] != pseudo_board[y+3*vec.y][x+3*vec.x]:
					continue
				if winner == Winner.NONE:
					winner = pseudo_board[y][x]
				elif winner != pseudo_board[y][x]:
					return Winner.BOTH
	
	return winner
