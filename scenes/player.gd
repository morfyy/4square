extends Node
class_name Player

enum Type {
	LOCAL=0,
	CPU,
	REMOTE # no implementation
}

var id:int = 0 # basically index, game.gd needs to make sure it always is
var username:String = "Player"
var type:Type = Type.LOCAL
var is_active:bool = false

signal marble_submitted(by_player:int,tileindex:int,holeindex:int)
signal slide_submitted(by_player:int,tileindex:int,dir:Vector2i)
# id - from which player
# index - at which hole
