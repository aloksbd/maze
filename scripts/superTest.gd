extends Area2D


func _on_superTest_body_entered(body):
	if "blue" in body.name:
		print("you win")
		get_node("/root/testLevel/CanvasLayer/inGameUI").gameCompleted()

