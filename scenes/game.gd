extends Control
class_name Game


var player_pck:PackedScene = preload("res://scenes/player.tscn")

@onready var board:Board = $board/Board
var gridsize:Vector2i = Vector2i(5,5)

@onready var players:Node = $players
var active_player:int = 0

func get_active_player() -> Player:
	return players.get_child(active_player)



func _ready() -> void:
	signals.connect("local_move_requested", local_move_requested)




func create(my_gridsize:Vector2i) -> void:
	gridsize = my_gridsize
	board.generate(my_gridsize)

func add_player(player_name:String, player_type:Player.Type) -> void:
	var new_player:Player = player_pck.instantiate()
	new_player.username = player_name
	new_player.type = player_type
	
	new_player.id = players.get_child_count()
	
	if new_player.id == 0:
		new_player.is_active = true
	
	players.add_child(new_player)
	new_player.connect("move_submitted", move_submitted)



func local_move_requested(at_hole:int) -> void:
	if get_active_player().type != Player.Type.LOCAL:
		return
	move_submitted(get_active_player().id, at_hole)


func move_submitted(by:int, at_hole:int) -> void:
	if get_active_player().id != by:
		return
	
	board.get_child(at_hole).set_value(by)

	get_active_player().is_active = false
	active_player += 1
	active_player = active_player % players.get_child_count()
	get_active_player().is_active = true
	
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
