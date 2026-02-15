extends TextureButton
class_name Tile


var tilepos:Vector2i = Vector2i()
@onready var holes:Control = $holes

func _ready() -> void:
	disabled = true
	for i:int in range(holes.get_child_count()):
		holes.get_child(i).gridpos.x = 2*tilepos.x + i % 2
		holes.get_child(i).gridpos.y = 2*tilepos.y + int(float(i)/2)
	connect("pressed", pressed)


func pressed() -> void:
	var dir:Vector2i = Vector2i(0,0)
	for ray in $Area2D.get_children():
		if not ray is RayCast2D:
			continue
		if not ray.is_colliding():
			dir = Vector2i(ray.target_position.normalized())
			break
	
	if dir == Vector2i(0,0):
		#var tween:Tween = get_tree().create_tween()
		#tween.tween_property(tile,"position:x",position.x-size.x*0.05,0.1)
		#tween.tween_property(tile,"position:x",position.x+size.x*0.05,0.1)
		#tween.tween_property(tile,"position:x",position.x-size.x*0.02,0.1)
		#tween.tween_property(tile,"position:x",position.x+size.x*0.02,0.1)
		#tween.tween_property(tile,"position:x",position.x,0.1)
		return
	
	signals.local_slide_submitted.emit(tilepos, dir)


func set_tilesize(to:Vector2) -> void:
	size = to
	for h in $holes.get_children():
		h.size = to * 0.5
	$holes/Hole2.position.x = to.x*0.5
	$holes/Hole3.position.y = to.y*0.5
	$holes/Hole4.position = to*0.5
	
	$Area2D.position = to * 0.5
	$Area2D.scale = to/Vector2(256,256)
