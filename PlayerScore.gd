extends Node

export var score = 0

signal score_changed(value)

onready var myScore = score setget update_score

func _ready():
	pass # Replace with function body.

func update_score(value):
	myScore = value
	emit_signal("score_changed", myScore)
