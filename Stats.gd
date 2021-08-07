extends Node


export var max_health = 1 setget set_max_health
var health = max_health setget set_health
var god_mode: bool = false setget update_god_mode

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal update_god_mode

func _ready():
	self.health = max_health
	

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed")

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func update_god_mode(value: bool):
	god_mode = value
	emit_signal("update_god_mode")
