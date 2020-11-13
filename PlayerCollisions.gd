extends Area2D

var activity
var person

func _process(delta):
	if monitoring:
		if get_parent().collisions == name:
			var overlap = get_overlapping_areas()
			if overlap.size() > 0:
				activity = "none"
				person = "none"
				for area in overlap:
					if area.is_in_group("Activity"):
						if activity == "none":
							activity = area.name
						get_node("../Use").visible = true
					if area.is_in_group("Person"):
						pass
			else:
				activity = "none"
				person = "none"
				get_node("../Use").visible = false
			get_parent().activity = activity
			get_parent().person = person
