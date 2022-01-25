extends 'Multiplayer.gd'


var host_id : int
var max_players : int = 32
var port : int = 2774


func _ready():
	_connect()


func _exit_tree():
	_disconnect()


func _connect():
	multiplayer.connect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.connect('network_peer_disconnected', self, '_on_peer_disconnected')


func _disconnect():
	multiplayer.disconnect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.disconnect('network_peer_disconnected', self, '_on_peer_disconnected')


func create():
	print('[Server] Creating')
	_create_server(port, max_players)


func _on_peer_connected(id):
	print('[Server] Peer connected with ID ', id)
	rpc('_rpc_received')


func _on_peer_disconnected(id):
	print('[Server] Peer disconnected with ID ', id)


remote func _rpc_received():
	print('[Server] RPC received from ', multiplayer.get_rpc_sender_id())
