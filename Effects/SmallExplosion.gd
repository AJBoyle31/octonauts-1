extends Explosion



func _on_SmallExplosion_animation_finished():
	queue_free()
