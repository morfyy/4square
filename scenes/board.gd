extends NinePatchRect
class_name Board

var hole_pck:PackedScene = preload("res://scenes/hole.tscn")


func _ready() -> void:
	generate(Vector2i(6,6))

func generate(gridsize:Vector2i) -> void:
	var hole_size:Vector2 = Vector2(size.x/gridsize.x, size.y/gridsize.y)
	
	for child in get_children():
		child.queue_free()
	
	var index:int = 0
	for x in range(gridsize.x):
		for y in range(gridsize.y):
			var inst:Hole = hole_pck.instantiate()
			inst.index = index
			inst.size = hole_size
			inst.position.x = x*hole_size.x
			inst.position.y = y*hole_size.y
			add_child(inst)
			index += 1
