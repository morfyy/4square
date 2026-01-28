extends TextureButton
class_name Hole

var index:int = 0

var value:int = 0
signal request_placement(int)

func _on_pressed() -> void:
	request_placement.emit(index)




func set_value(to:int):
	value = to
	$red.visible = to == 1
	$blue.visible = to == 2
