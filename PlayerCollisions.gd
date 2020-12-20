extends Area2D

var activity

func _process(delta):
	if monitoring:
		if get_parent().collisions == name:
			var overlap = get_overlapping_areas()
			if overlap.size() > 1:
				activity = "none"
				get_node("../Buttons/Use").visible = false
				for area in overlap:
					if area.is_in_group("Activity"):
						if activity == "none":
							activity = area.name
						get_node("../Buttons/Use").visible = true
					
			else:
				activity = "none"
				get_node("../Buttons/Use").visible = false
			get_parent().activity = activity
