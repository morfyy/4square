extends MobileControl
class_name MiniMenu

@onready var panel:Panel = $Panel
@onready var btn1:Button = $btn1
@onready var btn2:Button = $btn2
@onready var label:Label = $Label


func _ready() -> void:

	visible = false
	panel.modulate.a = 0.0
	btn1.modulate.a = 0.0
	btn2.modulate.a = 0.0
	label.scale = Vector2(0.8,0.8)
	

func unpop() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel().tween_property(panel, "modulate:a", 0.0, 0.25)
	tween.parallel().tween_property(btn1, "modulate:a", 0.0, 0.25)
	tween.parallel().tween_property(btn2, "modulate:a", 0.0, 0.25)
	tween.parallel().tween_property(label, "scale", Vector2(0.8,0.8), 0.25).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(_ready)

func pop() -> void:
	visible = true
	var tween:Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel()
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	tween.tween_property(btn1, "modulate:a", 1.0, 0.5)
	tween.tween_property(btn2, "modulate:a", 1.0, 0.5)
	#tween.tween_property(label, "modulate:a", 1.0, 0.25)
	tween.tween_property(label, "scale", Vector2(1.0,1.0), 0.5).set_trans(Tween.TRANS_SPRING)
