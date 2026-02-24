extends Node
class_name Player

enum Type {
	LOCAL=0,
	CPU,
	REMOTE # no implementation
}

@export var id:int = 0 # basically index, game.gd needs to make sure it always is
@export var username:String = "Player"
@export var type:Type = Type.LOCAL
@export var is_active:bool = false

signal marble_submitted(by_player:int,gridpos:Vector2i)
signal slide_submitted(by_player:int,tilepos:Vector2i,dir:Vector2i)

var board:Board = null



func game_started() -> void:
	pass


func game_ended(_draw:bool, _winner:Board.Winner) -> void:
	pass



func turn_ended() -> void:
	is_active = false

func turn_started() -> void:
	is_active = true
	
	if not type == Type.CPU:
		return
	
	
	var timer:SceneTreeTimer = get_tree().create_timer(1.0)
	timer.timeout.connect(cpu_marble)


func cpu_marble() -> void:
	if board.state != Board.State.AWAITING_MARBLE:
		return
	
	marble_submitted.emit(id, board.get_empty_holepos().pick_random())
	
	var timer:SceneTreeTimer = get_tree().create_timer(0.5)
	timer.timeout.connect(cpu_slide)


func cpu_slide() -> void:
	if board.state != Board.State.AWAITING_SLIDE:
		return
	
	var movable_tiles:Array[Tile] = board.get_movable_tiles()
	
	var rand:int = randi_range(0,movable_tiles.size()-1)
	slide_submitted.emit(id, movable_tiles[rand].tilepos, movable_tiles[rand].get_movable_dir())





func zipped_board() -> Array[int]:
	# assign every tile state a unique number from 0 to 82
	var out:Array[int] = []
	for y in range(0,board.tilegrid_size.y):
		for x in range(0,board.tilegrid_size.x):
			if board.pseudo_board[2*y][2*x] == -2:
				out.append(0)
				continue
			var tertiary:int = 0
			tertiary += (board.pseudo_board[2*y][2*x]+1)
			tertiary += (board.pseudo_board[2*y][2*x+1]+1)*3
			tertiary += (board.pseudo_board[2*y+1][2*x]+1)*9
			tertiary += (board.pseudo_board[2*y+1][2*x+1]+1)*27
			out.append(tertiary+100) # +100 so empty position matters a lot
	return out
