extends Area2D

var person
var show

func _process(deltas):
	if get_parent().is_network_master() && get_parent().killer == true && get_parent().place != "Lobby":
		var overlap = get_overlapping_areas()
		show = 0
		for area in overlap:
			if area.is_in_group("Person"):
				if area.get_parent() != get_parent():
					show = 1
					person = area.get_parent().name
					get_parent().person = person
					get_node("../Buttons/Kill").visible = true
		if show == 0:
			get_node("../Buttons/Kill").visible = false
