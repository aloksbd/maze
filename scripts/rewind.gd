extends Node2D

enum{
	RECORD,
	REWIND
}

var state = RECORD
var moves = []
var animations = []

func record(move,animation):
	moves.append(move)
	animations.append(animation)

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
	
	var animation = animations.pop_back()
	if moves.size() > 1:
		get_parent().animateTo(animations[-1])
	
