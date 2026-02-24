extends Control
class_name Menu

var game_pck:PackedScene = preload("res://scenes/game.tscn")


func _ready() -> void:
	pass


func _on_start_pressed() -> void:
	var new_game:Game = game_pck.instantiate()
	get_tree().root.add_child(new_game)
	new_game.create(
		Vector2i(3,3), [Vector2i(1,1)], 
		"Player 1", Player.Type.CPU, 
		"Player 2", Player.Type.CPU
		)
	hide()
