extends KinematicBody2D
class_name Fish

var fishDeath = preload("res://Effects/FishDeath.tscn")

export var ACCELERATION = 500
export var FRICTION = 400
export var MAX_SPEED = 75
export var wanderTimer = 1
export var random: bool = false

var randomSpeed = RandomNumberGenerator.new()
var randomTimer = RandomNumberGenerator.new()

var state = WANDER
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var timer = $Timer

enum {
	WANDER,
	CHASE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if random: 
		randomSpeed.randomize()
		randomTimer.randomize()
		MAX_SPEED = randomSpeed.randi_range(50, 100)
		timer.wait_time = randomTimer.randf_range(0.5, 4.5)
	

func _physics_process(delta):
	match state:
		WANDER:
			wander_state(delta)
		CHASE:
			pass
			#chase_state(delta)

func move():
	velocity = move_and_slide(velocity)

func wander_state(delta):
	velocity = velocity.move_toward(Vector2(1,0) * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	move()

func chase_state():
	pass

func fish_death():
	var death = fishDeath.instance()
	get_parent().add_child(death)
	death.global_position = global_position

func _on_Timer_timeout():
	if state == WANDER:
		MAX_SPEED = MAX_SPEED * -1
		

func _on_Hurtbox_area_entered(area):
	fish_death()
	queue_free()
