extends Control



func _on_LineEdit_text_changed(new_text):
	if new_text == "":
		return
	Network.data["nickname"] = new_text

func _on_LineEdit2_text_changed(new_text):
	if new_text == "":
		return
	Network._ip = new_text

func _on_Join_pressed():
	Network.connect_to_server()

