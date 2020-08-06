extends Area2D

export var xMin = -27
export var xMax = 153
export var yMin = -31
export var yMax = 155
onready var animationState = $AnimationTree.get("parameters/playback")

onready var ray = $RayCast2D
onready var ray2 = $RayCast2D2

enum{
	up,
	left,
	right,
	down
}

var dir = left

var speed = 50 # big number because it's multiplied by delta
var tile_size = 8 # size in pixels of tiles on the grid

var last_position = Vector2() # last idle position
var target_position = Vector2() # desired position to move towards
var movedir = Vector2() # move direction

func getDir():
	randomize()
	var currentDir = dir
	while currentDir == dir:
		dir = randi()%4

func _ready():
	#getDir()
	randomPos()
	position = position.snapped(Vector2(tile_size, tile_size)) # make sure player is snapped to grid
	last_position = position
	target_position = position
	
	
func randomPos():
	randomize()
	var x = xMin + randi()%(xMax)
	var y = yMin + randi()%yMax
	var cell1 = get_node("/root/testLevel/wallTile").get_cell(x,y)
	var cell2 = get_node("/root/testLevel/wallTile").get_cell(x-1,y)
	var cell3 = get_node("/root/testLevel/wallTile").get_cell(x-1,y-1)
	var cell4 = get_node("/root/testLevel/wallTile").get_cell(x,y-1)
	while cell1 != -1 || cell2 != -1 || cell3 != -1 || cell4 != -1:
		x = (x + 1)%xMax 
		y = (y + 1)%yMax

		cell1 = get_node("/root/testLevel/wallTile").get_cell(x,y)
		cell2 = get_node("/root/testLevel/wallTile").get_cell(x-1,y)
		cell3 = get_node("/root/testLevel/wallTile").get_cell(x-1,y-1)
		cell4 = get_node("/root/testLevel/wallTile").get_cell(x,y-1)
	position = Vector2(x*8,y*8)
	
func _process(delta):
	# MOVEMENT
	if ray.is_colliding() || ray2.is_colliding():
		position = last_position
		target_position = last_position
		getDir()
	else:
		position += speed * movedir * delta
		
		if position.distance_to(last_position) >= tile_size - speed * delta: # if we've moved further than one space
			position = target_position # snap the player to the intended position
	
	# IDLE
	if position == target_position:
		get_movedir()
		last_position = position # record the player's current idle position
		target_position += movedir * tile_size # if key is pressed, get new target (also shifts to moving state)

# GET DIRECTION THE PLAYER WANTS TO MOVE
func get_movedir():
	match dir:
		up:
			movedir = Vector2(0,-1)
		left:
			movedir = Vector2(-1,0)
		right:
			movedir = Vector2(1,0)
		down:
			movedir = Vector2(0,1)
	
	ray.position =  movedir * 4
	ray.position = Vector2(ray.position.y,ray.position.x)
	ray2.position = movedir * -4
	ray2.position = Vector2(ray2.position.y,ray2.position.x)
	
	if movedir.x != 0 && movedir.y != 0: # prevent diagonals
		movedir = Vector2.ZERO
	if movedir != Vector2.ZERO:
		ray.cast_to = movedir * tile_size
		ray2.cast_to = movedir * tile_size

	$AnimationTree.set("parameters/idle/blend_position",movedir)
	$AnimationTree.set("parameters/walk/blend_position",movedir)
	animationState.travel("walk")
	#$AnimationTree.set("parameters/idle/blend_position",animation_vector)
	#$AnimationTree.set("parameters/walk/blend_position",animation_vector)
	#animationState.travel("walk")


func _on_npc_body_entered(body):
	if "blue" in body.name:
		if body.rewinding:
			return
		get_tree().paused=true
		yield(get_tree().create_timer(0.5),"timeout")
		var gameover = get_node("/root/testLevel/CanvasLayer/inGameUI").rewind()
		if !gameover:
			get_tree().paused=false
			body.rewind()
		
		
