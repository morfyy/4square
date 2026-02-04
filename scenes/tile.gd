extends NinePatchRect
class_name Tile

var tileindex:int = 0

func _ready() -> void:
	for i:int in range(get_child_count()):
		get_child(i).holeindex = i
		get_child(i).connect("hole_pressed", hole_pressed)



func hole_pressed(holeindex:int) -> void:
	if get_child(holeindex).value >= 0:
		return
	signals.local_move_requested.emit(tileindex, holeindex)


func set_tilesize(to:Vector2) -> void:
	size = to
	for h:Hole in get_children():
		h.size = to * 0.5
	$Hole2.position.x = to.x*0.5
	$Hole3.position.y = to.y*0.5
	$Hole4.position = to*0.5
