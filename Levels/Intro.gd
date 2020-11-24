extends Node2D

const newScene = preload("res://World.tscn")

onready var player = $Player

func _ready():
	player.alive = false



func _on_Button_pressed():
	get_tree().change_scene_to(newScene)
