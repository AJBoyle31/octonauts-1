extends AnimatedSprite
class_name Explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	play("animate")


func _on_ExplosionEffect_animation_finished():
	queue_free()
