extends Area2D



func _on_test_body_entered(body):
	if "blue" in body.name:
		print("test")
		queue_free()
		get_node("/root/testLevel/CanvasLayer/inGameUI").testCollected()
