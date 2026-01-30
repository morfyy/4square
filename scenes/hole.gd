extends TextureButton
class_name Hole

var index:int = 0

var value:int = -1

func _on_pressed() -> void: 
	if value >= 0:
		return
	signals.local_move_requested.emit(index)


func set_value(to:int):
	value = to
	$red.visible = to == 0
	$blue.visible = to == 1
