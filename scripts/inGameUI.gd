extends Control

var clock = 0
var test = 0
export var totalTest = 3
var time = 0
var gameover = false

func _ready():
	timer()
	$Label.text = "X " + str(clock)
	$Label2.text = str(test) + "/" + str(totalTest)
	
func timer():
	if gameover:
		return
	$Label3.text = str(time)
	yield(get_tree().create_timer(1),"timeout")
	time += 1
	timer()

func clockCollected():
	clock += 1
	$Label.text = "X " + str(clock)
	
	
func testCollected():
	test += 1
	$Label2.text = str(test) + "/" + str(totalTest)

func rewind() -> bool:
	if clock == 0:
		print("gameover")
		gameover = true
		return false
	clock -= 1
	$Label.text = "X " + str(clock)
	return true
