extends Control

var game:PackedScene = preload("res://scenes/game.tscn")




func _on_start_pressed() -> void:
	var new_game:Game = game.instantiate()
	get_tree().root.add_child(new_game)
	new_game.create(Vector2i(5,5))
	queue_free()
