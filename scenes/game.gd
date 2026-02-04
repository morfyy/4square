extends Control
class_name Game


var player_pck:PackedScene = preload("res://scenes/player.tscn")
var menu_pck:PackedScene = preload("res://scenes/menu.tscn")

@onready var board:Board = $board/Board
var gridsize:Vector2i = Vector2i(5,5)
var empties:Array[Vector2i] = []
var turns_count:int = 0

@onready var players:Node = $players
var active_player:int = 0

@onready var icons:Array = [$player1/PlayerIcon, $player2/PlayerIcon]

func get_active_player() -> Player:
	return players.get_child(active_player)


@onready var minimenu:MiniMenu = $minimenu


func _ready() -> void:
	signals.connect("local_move_requested", local_move_requested)
	minimenu.btn1.connect("pressed", back_to_menu)
	minimenu.btn2.connect("pressed", restart_game)

# empties, where in grid to don't have tiles
func create(my_gridsize:Vector2i, my_empties:Array[Vector2i], p1name:String, p1type:Player.Type, p2name:String, p2type:Player.Type) -> void:
	gridsize = my_gridsize
	empties = my_empties
	board.generate(gridsize, empties)
	
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


func local_marble_submitted(tileindex:int, holeindex:int) -> void:
	if get_active_player().type != Player.Type.LOCAL:
		return
	marble_submitted(get_active_player().id, tileindex, holeindex)



func marble_submitted(by:int, tileindex:int, holeindex:int) -> void:
	if get_active_player().id != by:
		return
	turns_count += 1
	
	board.get_hole(tileindex,holeindex).set_value(by)

	get_active_player().is_active = false
	icons[active_player].deactivate()
	active_player = int(!bool(active_player))
	get_active_player().is_active = true
	icons[active_player].activate()
	
	pop_message(get_active_player().username+"'s turn!", [Color.RED,Color.BLUE][active_player] )
	
	# TODO check if won first
	
	if turns_count >= (gridsize.x * gridsize.y - empties.size())*4:
		draw_game()



func draw_game() -> void:
	get_tree().paused = true
	minimenu.label.text = "DRAW !"
	minimenu.btn1.text = "BACK TO MENU"
	minimenu.btn2.text = "PLAY AGAIN"
	minimenu.pop()



func back_to_menu() -> void:
	get_tree().paused = false
	get_tree().root.get_node("Menu").show()
	queue_free()

func restart_game() -> void:
	board.generate(gridsize, empties)
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
