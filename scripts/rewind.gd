extends Node2D

enum{
	RECORD,
	REWIND
}

var state = RECORD
var moves = []
var animations = []
var positions = []
var dontMove = false
var prePos = null

func record(move,animation,pos):
	moves.append(move)
	animations.append(animation)
	positions.append(pos)

func rewind():
	state = REWIND
	yield(get_tree().create_timer(3), "timeout")
	moves.clear()
	state = RECORD

func _physics_process(delta):
	if state == RECORD:
		return
		
	dontMove = false
	var pos = positions.pop_back()
	if positions.size() > 1:
		print(positions[-1],pos)
		if abs(positions[-1].x-pos.x) < 0.1 && abs(positions[-1].y-pos.y) < 0.1:
			dontMove = true
	
	var move = moves.pop_back()
	if move == null:
		move = Vector2.ZERO
	get_parent().moveTo(move)
	
	var animation = animations.pop_back()
	if moves.size() > 1:
		get_parent().animateTo(animations[-1])
	
