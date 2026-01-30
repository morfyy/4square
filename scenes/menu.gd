extends Control
class_name Menu

var game:PackedScene = preload("res://scenes/game.tscn")



func _on_start_pressed() -> void:
	var new_game:Game = game.instantiate()
	get_tree().root.add_child(new_game)
	new_game.create(Vector2i(5,5))
	new_game.add_player("Player 1", Player.Type.LOCAL)
	new_game.add_player("Player 2", Player.Type.LOCAL)
	queue_free()
