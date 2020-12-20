extends Area2D

var person

func process():
	var overlap = get_overlapping_areas()
	for area in overlap:
		if area.is_in_group("Person"):
			if get_parent().area != get_parent():
				person = area.get_parent().name

