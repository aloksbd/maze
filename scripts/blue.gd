extends KinematicBody2D

const max_speed = 80
var velocity = Vector2()
var input_vector = Vector2.ZERO
var animation_vector = Vector2.ZERO

onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	if $rewind.state == 0:
		input_vector.x = -Input.get_action_strength("ui_right") + Input.get_action_strength("ui_left")
		input_vector.y = -Input.get_action_strength("ui_down") + Input.get_action_strength("ui_up")
		if input_vector != Vector2.ZERO:
			animation_vector = input_vector
		$rewind.record(input_vector,animation_vector)
	
	if input_vector != Vector2.ZERO:
		$AnimationTree.set("parameters/idle/blend_position",animation_vector)
		$AnimationTree.set("parameters/walk/blend_position",animation_vector)
		animationState.travel("walk")
		input_vector = input_vector.normalized()
		velocity = input_vector * max_speed
		if $rewind.state == 1:
			velocity = input_vector * -max_speed
	else:
		animationState.travel("idle")
		velocity = Vector2.ZERO
	
	move_and_slide(velocity)
	input_vector = Vector2.ZERO

func moveTo(move):
	input_vector = move
	
func animateTo(move):
	animation_vector = move
	
func rewind():
	$rewind.rewind()
