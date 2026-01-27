extends Control
class_name Game

@onready var board:Board = $board/Board


func create(gridsize:Vector2i) -> void:
	board.generate(gridsize)
