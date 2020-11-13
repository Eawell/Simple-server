extends Node

var PORT = 4444
var _ip = "82.1.129.70"

var players = {}
var data = {"nickname" : "", "skin" : "white"}
var taken = []

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')


#i'm joining
func connect_to_server():
	print("connect_to_server")
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(_ip, PORT)
	get_tree().set_network_peer(peer)

#i have joined
func _connected_to_server():
	print("_connected_to_server")
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = data
	get_tree().change_scene("res://Lobby.tscn")
	rpc('_send_player_info', local_player_id, data)

#everyone individually adds the player that joined
remote func _send_player_info(id, info):
	print("_send_player_info")
	players[id] = info
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	$'/root/Lobby/'.add_child(new_player)
	new_player.init(info.nickname, info.skin, true)

#if another player joined the game that i'm in, i request info
func _on_player_connected(connected_player_id):
	if (connected_player_id == 1):
		return
	var local_player_id = get_tree().get_network_unique_id()
	rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

func _on_player_disconnected(id):
	if taken.has(players[id]["skin"]):
		taken.erase(players[id]["skin"])
	players.erase(id)

func change_skin(id, old_skin, new_skin):
	if !taken.has(new_skin):
		rpc('changed_skin', id, old_skin, new_skin)
	
sync func changed_skin(id, old_skin, new_skin):
	if old_skin != "white":
		taken.erase(old_skin)
	taken.append(new_skin)
	players[id]["skin"] = new_skin
	get_node("/root/Lobby/"+ str(id)).vis_skin(players[id]["skin"])

remote func check_taken(new_taken):
	taken = new_taken

func call_start():
	rpc('start_game')
	
sync func start_game():
	get_tree().change_scene("res://Map.tscn")

#ask for info of other player
#remote func _request_player_info(request_from_id, player_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])
