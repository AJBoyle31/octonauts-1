extends KinematicBody2D
class_name Mine

export (PackedScene) var explosionEffect
export var random: bool = false

var MAX_SPEED = 5
var ACCELERATION = 10
var randomVector = RandomNumberGenerator.new()
var randomSpeed = RandomNumberGenerator.new()
var randomAcceleration = RandomNumberGenerator.new()

var mine_vector = Vector2.ZERO
var velocity = Vector2.ZERO

onready var timer = $Timer

func _ready():
	randomVector.randomize()
	randomSpeed.randomize()
	randomAcceleration.randomize()
	if random:
		#mine_vector.x = randomVector.randi_range(-1,1)
		mine_vector.x = 0
		mine_vector.y = randomVector.randi_range(-1,1)
		MAX_SPEED = randomSpeed.randi_range(5,10)
		ACCELERATION = randomAcceleration.randi_range(10,30)
	else:
		mine_vector = Vector2.UP

func _physics_process(delta):
	velocity = velocity.move_toward(mine_vector * MAX_SPEED, ACCELERATION * delta)
	move()

func move():
	velocity = move_and_slide(velocity)


func create_explosion():
	var explosion = explosionEffect.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position


func _on_Hurtbox_area_entered(area):
	create_explosion()
	queue_free()


func _on_Timer_timeout():
	MAX_SPEED = MAX_SPEED * -1
	
