extends Area2D

var activity
var show

func _process(delta):
	if monitoring:
		if get_parent().collisions == name:
			var overlap = get_overlapping_areas()
			if overlap.size() > 1:
				activity = "none"
				show = 0
				for area in overlap:
					if area.is_in_group("Activity"):
						show = 1
						if activity == "none":
							activity = area.name
						get_node("../Buttons/Use").visible = true
				if show == 0:
					get_node("../Buttons/Use").visible = false
					
			else:
				activity = "none"
				get_node("../Buttons/Use").visible = false
			get_parent().activity = activity
