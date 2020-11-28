extends KinematicBody2D

var bubblesEffect = preload("res://Effects/BubblesEffect.tscn")

export var MAX_SPEED = 150
export var ACCELERATION = 400
export var RUSH_ACCELERATION = 600
export var FRICTION = 500
export var RUSH_SPEED = 300
export var FAST_SPEED = 225

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = MOVE
var rush_vector = Vector2.ZERO
var facingRight = true
var score = PlayerScore
var alive = true
var stats = PlayerStats

enum {
	MOVE,
	RUSH,
	FAST,
	HURT
}

onready var sprite = $AnimatedSprite

# 2048, 1200


func _ready():
	#score.myScore = 0
	stats.health = stats.max_health
	alive = true
	stats.connect("no_health", self, "_on_HUD_game_over")
	
func _physics_process(delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		MOVE:
			move_state(delta)
		RUSH:
			rush_state(delta)
		FAST:
			fast_state(delta)
		HURT:
			hurt_state(delta)
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	if alive:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			rush_vector = input_vector
			sprite.flip_h = input_vector.x < 0
			sprite.play("swim")
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		move()
		
		if Input.is_action_pressed("rush"):
			state = RUSH
		
		if Input.is_action_pressed("fast"):
			state = FAST
	

func rush_state(delta):
	velocity = velocity.move_toward(rush_vector * RUSH_SPEED, RUSH_ACCELERATION * delta)
	sprite.play("rush")
	move()
	if sprite.frames.get_frame_count("rush")-1 == sprite.frame:
		state = MOVE

func fast_state(delta):
	if Input.is_action_just_released("fast"):
		state = MOVE
	else:
		velocity = rush_vector * FAST_SPEED
		sprite.play("fast")
		move()

func hurt_state(delta):
	knockback = -rush_vector * 75
	sprite.play("hurt")
	if sprite.frames.get_frame_count("hurt")-1 == sprite.frame:
		velocity = Vector2.ZERO
		state = MOVE


func move():
	velocity = move_and_slide(velocity)


func _on_BubblesTimer_timeout():
	var bubbles = bubblesEffect.instance()
	get_parent().add_child(bubbles)
	bubbles.global_position = global_position



func _on_Hurtbox_area_entered(area):
	state = HURT
	stats.health += area.get_parent().damage


func _on_HUD_game_over():
	alive = false
	sprite.play("idle")


func _on_Hitbox_area_entered(area):
	score.myScore += area.get_parent().score
