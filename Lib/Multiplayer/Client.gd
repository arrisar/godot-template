extends 'Multiplayer.gd'


var id
var host : String = '127.0.0.1'
var port : int = 2774

var elapsed : float = 0
var created : bool = false


func _ready():
	_connect()


func _connect():
	multiplayer.connect('server_disconnected', self, '_on_connection_closed')
	multiplayer.connect('connection_failed', self, '_on_connection_failed')
	multiplayer.connect('connected_to_server', self, '_on_connection_success')
	multiplayer.connect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.connect('network_peer_disconnected', self, '_on_peer_disconnected')


func create():
	print('[Client] Creating')
	_create_client(host, port)
	print('[Client] Created')


func _on_connection_closed():
	print('[Client] Connection closed')
	close()


func _on_connection_failed():
	print('[Client] Failed to connect')
	close()


func _on_connection_success():
	print('[Client] Connected')
	rpc('_rpc_received')


func _on_peer_connected(id):
	print('[Client] Peer connected with ID ', id)


func _on_peer_disconnected(id):
	print('[Client] Peer disconnected with ID ', id)


remote func _rpc_received():
	print('[Client] RPC received from ', multiplayer.get_rpc_sender_id())
