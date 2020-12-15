extends Area2D



export var level_number: int
export var previous_level: bool = false

func _on_NextLevel_body_entered(body):
	var fish_left = get_tree().get_nodes_in_group("Fish").size()
	if previous_level || fish_left == 0:
		get_tree().change_scene("res://Levels/Level" + str(level_number) + ".tscn")
	

