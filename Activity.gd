extends Area2D


func _process(delta):
	if get_overlapping_areas().size() > 0:
		scale = Vector2(1.1,1.1)
	else:
		scale = Vector2(1,1)
