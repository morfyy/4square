extends Control
class_name MobileControl

# DON'T MODIFY SCALE OF THIS NODE IN EDITOR
# OR ANIMATE
@export var mobile_scale_multiplier:float = 2.0
@export var portrait_scale_multiplier:float = 2.0

var on_mobile:bool = false

func _ready() -> void:
	on_mobile = OS.get_name()=="Android" or OS.get_name()=="iOS"
	on_mobile = true # debug
	get_window().size_changed.connect(on_window_size_changed)
	on_window_size_changed()

func on_window_size_changed() -> void:
	if get_window().size.x > get_window().size.y:
		scale = Vector2(1,1)
	else:
		scale = Vector2(1,1)*portrait_scale_multiplier
	if on_mobile:
		scale *= mobile_scale_multiplier
