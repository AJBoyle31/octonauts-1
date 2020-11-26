extends Area2D


export var next_level: PackedScene


func _on_NextLevel_body_entered(body):
	var fish_left = get_tree().get_nodes_in_group("Fish").size()
	if fish_left == 0:
		get_tree().change_scene_to(next_level)
	
