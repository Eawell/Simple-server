extends Node

const PORT = 4031
const _IP = "127.0.0.1"

var players = {}
var data = {"nickname" : "", "pos" : Vector2()}
var taken = []

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')

#i'm joining
func connect_to_server():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(_IP, PORT)
	get_tree().set_network_peer(peer)

#i have joined
func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = data
	rpc('_send_player_info', local_player_id, data)

#everyone individually updates the players' info
remote func _send_player_info(id, info):
	players[id] = info
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	$'/root/Game/'.add_child(new_player)
	new_player.init(info.nickname, info.pos, true)
	
#if another player joined the game that i'm in, i request info
func _on_player_connected(connected_player_id):
	if (connected_player_id == 1):
		return
	if not(get_tree().is_network_server()):
		var local_player_id = get_tree().get_network_unique_id()
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

#if someone leaves, get rid of their data
func _on_player_disconnected(id):
	players.erase(id)

#func update_position(id, position):
#	players[id].position = position

#ask for info of other player
#remote func _request_player_info(request_from_id, player_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])
