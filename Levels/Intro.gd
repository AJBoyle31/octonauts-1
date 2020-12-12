extends Node2D

export var next_level: PackedScene 

onready var player = $Player


func _ready():
	player.alive = false



func _on_Button_pressed():
	get_tree().change_scene_to(next_level)
