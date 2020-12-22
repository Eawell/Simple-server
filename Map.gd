extends Node2D


func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	
	var local_player_id = get_tree().get_network_unique_id()
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(local_player_id)
	new_player.set_network_master(local_player_id)
	new_player.global_position = Vector2(600,300)
	add_child(new_player)
	new_player.init(Network.players[local_player_id]["nickname"], Network.players[local_player_id]["skin"], false)
	
	for player in Network.players:
		if player == local_player_id:
			print("yeeees")
		else:
			print("TWOOO")
			var other_player = load('res://Player.tscn').instance()
			other_player.name = str(player)
			other_player.set_network_master(player)
			add_child(other_player)
			other_player.init(Network.players[player].nickname, Network.players[player].skin, true)

	
func _on_player_disconnected(id):
	get_node(str(id)).queue_free()

func _on_server_disconnected():
	get_tree().change_scene('res://Join_Menu.tscn')
