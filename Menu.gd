extends Control

var x = 0
var y = 0


func _on_LineEdit_text_changed(new_text):
	if new_text == "":
		return
	Network.data["nickname"] = new_text

func _on_LineEdit2_text_changed(new_text):
	if new_text == "":
		return
	x = new_text
	Network.data["pos"] = Vector2(x,y)

func _on_LineEdit3_text_changed(new_text):
	if new_text == "":
		return
	y = new_text
	Network.data["pos"] = Vector2(x,y)


func _on_Join_pressed():
	Network.connect_to_server()
	get_tree().change_scene("res://Game.tscn")
