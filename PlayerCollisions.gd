extends Area2D

func _process(delta):
	if monitoring:
		print(collision_layer)
		if get_parent().collisions == name:
			var overlap = get_overlapping_areas()
			if overlap.size() > 0:
				var area = overlap[0]
				if area.is_in_group("Activity"):
					get_node("../Use").visible = true
			else:
				get_node("../Use").visible = false
