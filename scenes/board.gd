extends NinePatchRect
class_name Board

var tile_pck:PackedScene = preload("res://scenes/tile.tscn")

signal slide_finished

var pseudo_board:Array = []
var tilegrid_size:Vector2i = Vector2i()
var empties:Array[Vector2i] = []

func generate(my_tilegrid_size:Vector2i, my_empties:Array[Vector2i]) -> void:
	tilegrid_size = my_tilegrid_size
	empties = my_empties
	var tile_size:Vector2 = Vector2(size.x/tilegrid_size.x, size.y/tilegrid_size.y)
	
	for child in get_children():
		child.queue_free()
	
	for y in range(tilegrid_size.y):
		for x in range(tilegrid_size.x):
			if Vector2i(x,y) in empties:
				continue
			var inst:Tile = tile_pck.instantiate()
			inst.tilepos = Vector2i(x,y)
			inst.set_tilesize(tile_size)
			inst.position.x = x*tile_size.x
			inst.position.y = y*tile_size.y
			add_child(inst)
	
	pseudo_board.clear()
	for y in range(tilegrid_size.y*2):
		pseudo_board.append([])
		for x in range(tilegrid_size.x*2):
			pseudo_board[y].append(-1)

func reset() -> void:
	generate(tilegrid_size, empties) # TODO PLS FIX LATER NOT EFFICIENT


func place_marble(by_player:int, gridpos:Vector2i) -> void:
	for tile:Tile in get_children():
		tile.disabled = false
		for hole:Hole in tile.holes.get_children():
			if hole.gridpos == gridpos:
				hole.set_value(by_player)
			hole.disabled = true
		
	

func slide_tile(tilepos:Vector2i, dir:Vector2i) -> void:
	for tile:Tile in get_children():
		tile.disabled = true
		if tile.tilepos != tilepos:
			continue
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(tile, "position", tile.position+Vector2(dir)*tile.size, 0.3).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(after_slide)

func after_slide() -> void:
	slide_finished.emit()
	for tile:Tile in get_children():
		tile.disabled = true
		for hole:Hole in tile.holes.get_children():
			hole.disabled = false


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
