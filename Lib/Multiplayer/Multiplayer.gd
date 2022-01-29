extends Node


var network: NetworkedMultiplayerENet


func _init() -> void:
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.set_root_node(self)


func _process(_delta: float) -> void:
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()


func _create_server(port: int, max_players: int) -> void:
	network = NetworkedMultiplayerENet.new()
	network.create_server(port, max_players)
	multiplayer.set_network_peer(network)


func _create_client(host: String, port: int) -> void:
	network = NetworkedMultiplayerENet.new()
	network.create_client(host, port)
	multiplayer.set_network_peer(network)


func close(wait: int = 0):
	if network != null:
		network.close_connection(wait)
		custom_multiplayer.set_network_peer(null)
		network = null


func get_sender_id() -> int:
	return multiplayer.get_rpc_sender_id()
