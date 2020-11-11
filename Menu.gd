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
	if Network.data["nickname"] != "":
		Network.connect_to_server()


func _on_CheckBox_toggled(button_pressed):
	if $CheckBox.pressed == true:
		Network.PORT = 4031
	else:
		Network.PORT = 4444
