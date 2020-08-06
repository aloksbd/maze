extends Control

func _ready():
	$Label/AnimationPlayer.play("blink")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/menu.tscn")
