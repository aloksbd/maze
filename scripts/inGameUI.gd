extends Control

var clock = 0
var test = 0
export var totalTest = 3
var time = 0
var gameover = false
export var nextLevel = ""

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
		$gameover.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		get_tree().paused=false
		get_tree().change_scene("res://scenes/postGameLose.tscn")
	else:
		clock -= 1
		$Label.text = "X " + str(clock)
	return gameover
	
func gameCompleted():
	if test < totalTest:
		return
	get_tree().paused=true
	yield(get_tree().create_timer(0.5),"timeout")
	$win.visible = true
	yield(get_tree().create_timer(1.5),"timeout")
	get_tree().paused=false
	if nextLevel == "":
		get_tree().change_scene("res://scenes/postGameWin.tscn")
	else:
		get_tree().change_scene("res://scenes/"+nextLevel+".tscn")
