extends Node2D

export var positions = []

func _ready():
	for node in get_children():
		var i = randi()%positions.size() 
		node.position = positions[i]
		#positions.remove(i)
