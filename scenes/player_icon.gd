extends Node2D
class_name PlayerIcon



@export var color:Color = Color.WHITE


func _ready() -> void:
	$ColorRect.color = color


func activate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "scale", Vector2(1.0,1.0), 0.5).set_trans(Tween.TRANS_SPRING)
	tween.parallel().tween_property($Label, "modulate", color, 0.5).set_trans(Tween.TRANS_SPRING)


func deactivate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "scale", Vector2(0.9,0.7), 0.5)
	tween.parallel().tween_property($Label, "modulate", Color.WHITE, 0.5)
