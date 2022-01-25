extends Node


var network : NetworkedMultiplayerENet = null


func _init():
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.set_root_node(self)


func _process(_delta):
	if custom_multiplayer.has_network_peer() : custom_multiplayer.poll()


func _create_server(port, max_players):
	network = NetworkedMultiplayerENet.new()
	network.create_server(port, max_players)
	multiplayer.set_network_peer(network)


func _create_client(host, port):
	network = NetworkedMultiplayerENet.new()
	network.create_client(host, port)
	multiplayer.set_network_peer(network)


func close(wait = 0):
	network.close_connection(wait)
	custom_multiplayer.set_network_peer(null)
	network = null
