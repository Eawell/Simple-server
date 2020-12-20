extends Area2D


func _process(delta):
	scale = Vector2(1,1)
	for overlap in get_overlapping_areas():
		if overlap.get_parent().name == str(get_tree().get_network_unique_id()):
			scale = Vector2(1.1,1.1)

