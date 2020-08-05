extends Area2D

func _on_clock_body_entered(body):
	if "blue" in body.name:
		print("yay")
		queue_free()
		get_node("/root/testLevel/CanvasLayer/inGameUI").clockCollected()
