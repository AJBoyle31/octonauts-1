extends KinematicBody2D

var bubblesEffect: PackedScene = preload("res://Effects/BubblesEffect.tscn")

export var MAX_SPEED: int = 150
export var ACCELERATION: int = 400
export var RUSH_ACCELERATION: int = 600
export var FRICTION: int = 500
export var RUSH_SPEED: int = 300
export var FAST_SPEED: int = 225

var velocity: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var mouse_position: Vector2 = Vector2.ZERO
var player_state: String
var state = MOVE
var rush_vector: Vector2 = Vector2.ZERO
var facingRight: bool = true
var score = PlayerScore
var alive: bool = true
var stats = PlayerStats
var god_mode: bool = false

enum {
	MOVE,
	RUSH,
	FAST,
	HURT,
	MOUSE
}

onready var sprite = $AnimatedSprite
onready var camera = $Camera2D

# 2048, 1200


func _ready():
	#score.myScore = 0
	stats.health = stats.max_health
	alive = true
	stats.connect("no_health", self, "_on_HUD_game_over")
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("restart_level"):
		#get_tree().change_scene(get_tree().current_scene.filename)
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("god_mode"):
		god_mode = !god_mode
		stats.god_mode = god_mode
		
	
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
		MOUSE:
			mouse_state(delta)
	

func move_state(delta) -> void:
	var input_vector = Vector2.ZERO
	if alive:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			mouse_click("swim")
		elif  Input.is_mouse_button_pressed(BUTTON_RIGHT):
			mouse_click("fast")
		else: 
			if input_vector != Vector2.ZERO:
				rush_vector = input_vector
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
			

func mouse_click(button: String) -> void:
	mouse_position = get_global_mouse_position()
	player_state = button
	state = MOUSE

func mouse_state(delta) -> void:
	rush_vector = (mouse_position - self.global_position).normalized()
	match player_state:
		"swim": 
			sprite.play("swim")
			velocity = rush_vector * MAX_SPEED
		"fast":
			sprite.play("fast")
			velocity = rush_vector * FAST_SPEED
	move()
	if self.global_position.distance_to(mouse_position) < 3.0:
		state = MOVE
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		mouse_click("swim")
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		mouse_click("fast")

func rush_state(delta) -> void:
	velocity = velocity.move_toward(rush_vector * RUSH_SPEED, RUSH_ACCELERATION * delta)
	sprite.play("rush")
	move()
	if sprite.frames.get_frame_count("rush")-1 == sprite.frame:
		state = MOVE

func fast_state(delta) -> void:
	if Input.is_action_just_released("fast"):
		state = MOVE
	else:
		velocity = rush_vector * FAST_SPEED
		sprite.play("fast")
		move()

func hurt_state(delta) -> void:
	knockback = -rush_vector * 75
	sprite.play("hurt")
	if sprite.frames.get_frame_count("hurt")-1 == sprite.frame:
		velocity = Vector2.ZERO
		state = MOVE


func move() -> void:
	if rush_vector.x < 0:
		sprite.flip_h = true
	elif rush_vector.x > 0:
		sprite.flip_h = false
	velocity = move_and_slide(velocity)


func _on_BubblesTimer_timeout() -> void:
	var bubbles = bubblesEffect.instance()
	get_parent().add_child(bubbles)
	bubbles.global_position = global_position



func _on_Hurtbox_area_entered(area) -> void:
	state = HURT
	if !god_mode:
		stats.health += area.get_parent().damage


func _on_HUD_game_over() -> void:
	alive = false
	sprite.play("idle")


func _on_Hitbox_area_entered(area) -> void:
	score.myScore += area.get_parent().score
