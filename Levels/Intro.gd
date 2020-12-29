extends Node2D

export var next_level: PackedScene 

onready var player = $Player


func _ready():
	player.alive = false




func _on_JackButton_pressed():
	get_tree().change_scene("res://Levels/Level4.tscn")



func _on_ZoeyButton_pressed():
	get_tree().change_scene("res://Levels/Level8.tscn")
