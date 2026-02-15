extends Control
class_name Game


var player_pck:PackedScene = preload("res://scenes/player.tscn")
var menu_pck:PackedScene = preload("res://scenes/menu.tscn")


@onready var board:Board = $board/Board
var turns_count:int = 0

@onready var players:Node = $players
var active_player:int = 0

@onready var icons:Array = [$player1/PlayerIcon, $player2/PlayerIcon]

func get_active_player() -> Player:
	return players.get_child(active_player)


@onready var minimenu:MiniMenu = $minimenu


func _ready() -> void:
	signals.connect("local_marble_submitted", local_marble_submitted)
	signals.connect("local_slide_submitted", local_slide_submitted)
	minimenu.btn1.connect("pressed", back_to_menu)
	minimenu.btn2.connect("pressed", restart_game)
	board.connect("slide_finished", slide_finished)

# empties, where in grid to don't have tiles
func create(tilegrid_size:Vector2i, empties:Array[Vector2i], p1name:String, p1type:Player.Type, p2name:String, p2type:Player.Type) -> void:
	board.generate(tilegrid_size, empties)
	
	var p1:Player = player_pck.instantiate()
	var p2:Player = player_pck.instantiate()
	p1.username = p1name
	p2.username = p2name
	p1.type = p1type
	p2.type = p2type
	p1.id = 0
	p2.id = 1
	icons[0].set_label(p1name)
	icons[1].set_label(p2name)
	
	p1.is_active = true
	icons[0].activate()
	
	players.add_child(p1)
	players.add_child(p2)
	p1.connect("marble_submitted", marble_submitted)
	p2.connect("marble_submitted", marble_submitted)
	p1.connect("slide_submitted", slide_submitted)
	p2.connect("slide_submitted", slide_submitted)


func local_marble_submitted(gridpos:Vector2i) -> void:
	if get_active_player().type != Player.Type.LOCAL:
		return
	marble_submitted(active_player, gridpos)
	
func local_slide_submitted(tilepos:Vector2i, dir:Vector2i) -> void:
	if get_active_player().type != Player.Type.LOCAL:
		return
	slide_submitted(active_player, tilepos, dir)



func marble_submitted(by_player:int, gridpos:Vector2i) -> void:
	if active_player != by_player:
		return
	board.place_marble(by_player, gridpos)


func slide_submitted(by_player:int, tilepos:Vector2i, dir:Vector2i) -> void:
	if active_player != by_player:
		return
	board.slide_tile(tilepos, dir)


func slide_finished() -> void:
	turns_count += 1
	
	# check victory
	var winner:Board.Winner = board.get_winner()
	if winner != Board.Winner.NONE:
		gameover(false, winner)
		return
	
	# check draw
	if turns_count >= (board.tilegrid_size.x * board.tilegrid_size.y - board.empties.size())*4:
		gameover(true, winner)
		return
	
	# next turn
	get_active_player().is_active = false
	icons[active_player].deactivate()
	active_player = int(!bool(active_player))
	get_active_player().is_active = true
	icons[active_player].activate()
	
	pop_message(get_active_player().username+"'s turn!", [Color.RED,Color.BLUE][active_player] )



func gameover(game_draw:bool, winner:Board.Winner) -> void:
	get_tree().paused = true
	if game_draw:
		minimenu.label.text = "DRAW !"
	elif winner == Board.Winner.BOTH:
		minimenu.label.text = "TIE !"
	elif winner == Board.Winner.P1:
		minimenu.label.text = "RED WON !"
	else:
		minimenu.label.text = "BLUE WON !"
	minimenu.btn1.text = "BACK TO MENU"
	minimenu.btn2.text = "PLAY AGAIN"
	minimenu.pop()



func back_to_menu() -> void:
	get_tree().paused = false
	get_tree().root.get_node("Menu").show()
	queue_free()

func restart_game() -> void:
	board.reset()
	get_tree().paused = false
	minimenu.unpop()
	turns_count = 0



func pop_message(msg:String, msg_color:Color = Color.WHITE) -> void:
	$message/message_anim.stop()
	$message/message_anim.play("pop")
	$message/Label.text = msg
	$message/Label.add_theme_color_override("font_color", msg_color)



#func gridpos_to_index(gridpos:Vector2i) -> int:
#	return gridpos.y*gridsize.x + gridsize.x

#func index_to_gridpos(index:int) -> Vector2i:
#	return Vector2i( index%gridsize.x, int(float(index)/gridsize.y) )
