extends TextureButton
class_name Hole

var holeindex:int = 0
signal hole_pressed(_index:int)

var value:int = -1

func _ready() -> void:
	connect("pressed", _on_pressed)



func _on_pressed() -> void: 
	hole_pressed.emit(holeindex)


func set_value(to:int) -> void:
	value = to
	$red.visible = to == 0
	$blue.visible = to == 1
