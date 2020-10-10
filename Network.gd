extends Node

const PORT = 4031
const MAX_PLAYERS = 5

var players = {}
var data = {"name" : "", "pos" : Vector2()}

func _start():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
#	get_tree().connect('network_peer_connected', self, '_on_player_connected')

	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		if (players.has(player_id)):
			rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

#func _on_player_connected(connected_player_id):
#	var local_player_id = get_tree().get_network_unique_id()
#	var is_server = get_tree().is_network_server()
#	if not(is_server):
#		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

func _on_player_disconnected(id):
	players.erase(id)

remote func _send_player_info(id, info):
	players[id] = info
