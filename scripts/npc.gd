extends Area2D

onready var animationState = $AnimationTree.get("parameters/playback")

enum{
	up,
	left,
	right,
	down
}

var dir = up

func _ready():
	getDir()

func _physics_process(delta):
	checkPosition()
	var animation_vector = Vector2.ZERO
	match dir:
		up:
			animation_vector = Vector2(0,-1)
		left:
			animation_vector = Vector2(-1,0)
		right:
			animation_vector = Vector2(1,0)
		down:
			animation_vector = Vector2(0,1)
	
	translate(animation_vector * 50 * delta)
	$AnimationTree.set("parameters/idle/blend_position",animation_vector)
	$AnimationTree.set("parameters/walk/blend_position",animation_vector)
	animationState.travel("walk")
	#followPath2d(delta)
	
func getDir():
	randomize()
	var currentDir = dir
	while currentDir == dir:
		dir = randi()%4
	checkPosition()
		
func checkPosition():
	var pos = Vector2.ZERO
	match dir:
		up:
			pos = Vector2(position.x,position.y-8)
		left:
			pos = Vector2(position.x-8,position.y)
		right:
			pos = Vector2(position.x+8,position.y)
		down:
			pos = Vector2(position.x,position.y+8)
	var cell = get_node("/root/testLevel/wallTile").get_cell(int(pos.x/8), int(pos.y/8))#(pos.x,pos.y))
	if cell != -1:
		getDir()
		
func followPath2d(delta):
	var prePos = get_parent().position
	get_parent().set_offset(get_parent().get_offset() + (50 * delta))
	var pos = get_parent().position
	var animation_vector = Vector2.ZERO
	if prePos.x > pos.x+0.7:
		animation_vector = Vector2(-1,0)
	elif prePos.x < pos.x-0.7:
		animation_vector = Vector2(1,0)
	elif prePos.y < pos.y-0.7:
		animation_vector = Vector2(0,1)
	elif prePos.y > pos.y+0.7:
		animation_vector = Vector2(0,-1)
	$AnimationTree.set("parameters/idle/blend_position",animation_vector)
	$AnimationTree.set("parameters/walk/blend_position",animation_vector)
	animationState.travel("walk")

func _on_npc_body_entered(body):
	if "blue" in body.name:
		if body.rewinding:
			return
		get_tree().paused=true
		yield(get_tree().create_timer(0.5),"timeout")
		get_tree().paused=false
		if get_node("/root/testLevel/CanvasLayer/inGameUI").rewind():
			body.rewind()
		else: 
			get_tree().change_scene("res://scenes/menu.tscn")
		

func byArea(body):
	if "wall" in body.name:
		position.x = stepify(position.x,1)
		position.y = stepify(position.y,1)
		var xr = int(position.x)%8
		var yr = int(position.y)%8
		if xr < 4:
			position.x -= xr
		else:
			position.x += xr
		if yr < 4:
			position.y -= yr
		else:
			position.y += yr
		if name == "npc":
			print(name,position)
		getDir()
