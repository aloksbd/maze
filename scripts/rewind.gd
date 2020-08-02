extends Node2D

enum{
	RECORD,
	REWIND
}

var state = RECORD
var moves = []

func record(move):
	moves.append(move)

func rewind():
	state = REWIND
	yield(get_tree().create_timer(3), "timeout")
	moves.clear()
	state = RECORD

func _physics_process(delta):
	if state == RECORD:
		return
	
	var move = moves.pop_back()
	if move == null:
		move = Vector2.ZERO
	get_parent().moveTo(move)
	
