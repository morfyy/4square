extends Node
class_name Player

enum Type {
	LOCAL=0,
	CPU,
	REMOTE # no implementation
}

var id:int = 0 # basically index, game.gd needs to make sure it always is
var username:String = "Player"
var type:Type = Type.LOCAL
var is_active:bool = false

signal marble_submitted(by_player:int,gridpos:Vector2i)
signal slide_submitted(by_player:int,tilepos:Vector2i,dir:Vector2i)

var board:Board = null

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
	var pick:int = randi_range(0,movable_tiles.size()-1)
	slide_submitted.emit(id, movable_tiles[pick].tilepos, movable_tiles[pick].get_movable_dir())
