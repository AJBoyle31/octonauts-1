extends KinematicBody2D
class_name Fish

var fishDeath = preload("res://Effects/FishDeath.tscn")

export var ACCELERATION: int = 500
export var FRICTION: int = 400
export var MAX_SPEED: int = 75
export var wanderTimer: int = 1
export var random: bool = false

var randomSpeed = RandomNumberGenerator.new()
var randomTimer = RandomNumberGenerator.new()

var state = WANDER
var velocity: Vector2 = Vector2.ZERO
var swim_points
var swim_index: int = 0

onready var sprite = $AnimatedSprite
onready var timer = $Timer
onready var parent = get_parent()

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
	if parent is PathFollow2D:
		swim_points = parent.get_parent().curve.get_baked_points()

func _physics_process(delta):
	match state:
		WANDER:
			wander_state(delta)
		CHASE:
			pass
			#chase_state(delta)

func move():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	velocity = move_and_slide(velocity)

func wander_state(delta) -> void:
	if parent is PathFollow2D:
		timer.stop()
		var target = swim_points[swim_index]
		#print(global_position.distance_to(target))
		if global_position.distance_to(target) < 1:
			swim_index = wrapi(swim_index + 1, 0, swim_points.size())
			target = swim_points[swim_index]
		velocity = (target - global_position).normalized() * MAX_SPEED
	else:
		velocity = velocity.move_toward(Vector2(1,0) * MAX_SPEED, ACCELERATION * delta)
	move()

func chase_state() -> void:
	pass

func fish_death() -> void:
	var death = fishDeath.instance()
	get_parent().add_child(death)
	death.global_position = global_position

func _on_Timer_timeout() -> void:
	if state == WANDER:
		MAX_SPEED = MAX_SPEED * -1
		

func _on_Hurtbox_area_entered(area) -> void:
	fish_death()
	queue_free()
