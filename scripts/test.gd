extends Area2D

export var xMin = -27
export var xMax = 153
export var yMin = -31
export var yMax = 155

func _ready():
	randomPos()
	pass

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

func _on_test_body_entered(body):
	if "blue" in body.name:
		print("test")
		queue_free()
		get_node("/root/testLevel/CanvasLayer/inGameUI").testCollected()
