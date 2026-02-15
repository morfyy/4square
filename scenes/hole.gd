extends TextureButton
class_name Hole

var gridpos:Vector2i = Vector2i()

var value:int = -1

func _ready() -> void:
	connect("pressed", pressed)



func pressed() -> void: 
	if value == -1:
		signals.local_marble_submitted.emit(gridpos)


func set_value(to:int) -> void:
	value = to
	$red.visible = to == 0
	$blue.visible = to == 1


	
