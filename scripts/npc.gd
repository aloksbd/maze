extends Area2D

onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
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
		body.rewind()
