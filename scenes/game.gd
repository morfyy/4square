extends Control
class_name Game

@onready var board:Board = $board/Board

var gridsize:Vector2i

var players_turn:int = 1

func create(my_gridsize:Vector2i) -> void:
	gridsize = my_gridsize
	board.generate(my_gridsize)
	for hole in board.get_children():
		hole.request_placement.connect(placement_requested)


func placement_requested(index:int) -> void:
	if board.get_child(index).value == 0:
		board.get_child(index).set_value(players_turn)
		if players_turn == 1:
			players_turn = 2
		else:
			players_turn = 1


func gridpos_to_index(gridpos:Vector2i) -> int:
	return gridpos.y*gridsize.x + gridsize.x

func index_to_gridpos(index:int) -> Vector2i:
	return Vector2i( index%gridsize.x, int(index/gridsize.y) )
