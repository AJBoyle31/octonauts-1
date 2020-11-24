extends AnimatedSprite

func _ready():
	frame = 0
	play("animate")




func _on_FishDeath_animation_finished():
	queue_free()
