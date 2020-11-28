extends Node

var score: int


signal score_changed(value)

onready var myScore = score setget update_score

func _ready():
	checkScore()
	

func update_score(value):
	myScore = value
	score = myScore
	emit_signal("score_changed", myScore)


func checkScore():
	if myScore:
		score = myScore
	else:
		score = 0
		
