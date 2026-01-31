extends Control
class_name Game


var player_pck:PackedScene = preload("res://scenes/player.tscn")

@onready var board:Board = $board/Board
var gridsize:Vector2i = Vector2i(5,5)

@onready var players:Node = $players
var active_player:int = 0

@onready var icons:Array = [$player1/PlayerIcon, $player2/PlayerIcon]

func get_active_player() -> Player:
	return players.get_child(active_player)



func _ready() -> void:
	signals.connect("local_move_requested", local_move_requested)
	icons[0].activate()

func create(my_gridsize:Vector2i, p1name:String, p1type:Player.Type, p2name:String, p2type:Player.Type) -> void:
	gridsize = my_gridsize
	board.generate(my_gridsize)
	
	var p1:Player = player_pck.instantiate()
	var p2:Player = player_pck.instantiate()
	p1.username = p1name
	p2.username = p2name
	p1.type = p1type
	p2.type = p2type
	
	p1.id = 0
	p2.id = 1
	
	p1.is_active = true
	
	players.add_child(p1)
	players.add_child(p2)
	p1.connect("move_submitted", move_submitted)
	p2.connect("move_submitted", move_submitted)



func local_move_requested(at_hole:int) -> void:
	if get_active_player().type != Player.Type.LOCAL:
		return
	move_submitted(get_active_player().id, at_hole)


func move_submitted(by:int, at_hole:int) -> void:
	if get_active_player().id != by:
		return
	
	board.get_child(at_hole).set_value(by)

	get_active_player().is_active = false
	icons[active_player].deactivate()
	active_player = int(!bool(active_player))
	get_active_player().is_active = true
	icons[active_player].activate()
	
	pop_message(get_active_player().username+"'s turn!", [Color.RED,Color.BLUE][active_player] )




func pop_message(msg:String, msg_color:Color = Color.WHITE) -> void:
	$message/message_anim.stop()
	$message/message_anim.play("pop")
	$message/Label.text = msg
	$message/Label.add_theme_color_override("font_color", msg_color)



func gridpos_to_index(gridpos:Vector2i) -> int:
	return gridpos.y*gridsize.x + gridsize.x

func index_to_gridpos(index:int) -> Vector2i:
	return Vector2i( index%gridsize.x, int(float(index)/gridsize.y) )
