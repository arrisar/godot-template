extends 'Multiplayer.gd'


signal connected()
signal connection_closed()
signal connection_failed()
signal event(event, payload)
signal peer_connected(peer_id)
signal peer_disconnected(peer_id)
signal peer_list_updated(peers)


var CALLBACKS: Dictionary

var host_id: int
var peer_id: int

var host: String
var port: int
var password: String


func _ready() -> void:
	_connect()
	reset()


func _exit_tree() -> void:
	_disconnect()


func _connect() -> void:
	multiplayer.connect('server_disconnected', self, '_on_connection_closed')
	multiplayer.connect('connection_failed', self, '_on_connection_failed')
	multiplayer.connect('connected_to_server', self, '_on_connection_success')
	multiplayer.connect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.connect('network_peer_disconnected', self, '_on_peer_disconnected')


func _disconnect() -> void:
	multiplayer.disconnect('server_disconnected', self, '_on_connection_closed')
	multiplayer.disconnect('connection_failed', self, '_on_connection_failed')
	multiplayer.disconnect('connected_to_server', self, '_on_connection_success')
	multiplayer.disconnect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.disconnect('network_peer_disconnected', self, '_on_peer_disconnected')


func create() -> void:
	print('[Client] Creating')
	_create_client(host, port)


func close(wait: int = 0) -> void:
	print('[Client] Closing')
	.close(wait)


func reset() -> void:
	print('[Client] Resetting')
	host_id = 0
	peer_id = 0
	host = '127.0.0.1'
	port = 2774
	password = ''


func send_event(event: String, payload, unreliable: bool = false) -> void:
	if unreliable:
		rpc_unreliable_id(1, '_receive_event', event, payload)
	else:
		rpc_id(1, '_receive_event', event, payload)


remote func _receive_event(event, payload) -> void:
	if multiplayer.get_rpc_sender_id() == 1:
		emit_signal(event, payload)


func set_own_state(state: Dictionary) -> void:
	print('[Client] Sending own peer state')
	rpc_id(1, '_set_peer_state', peer_id, state)


func get_host_id(callback: FuncRef) -> void:
	var callback_id: int = callback.get_instance_id()
	print('[Client] Getting hots ID for callback with ID ', callback_id)
	CALLBACKS[callback_id] = callback
	rpc_id(1, '_get_host_id', callback_id)


func get_peers(callback: FuncRef, peer_id: int = 0) -> void:
	var callback_id: int = callback.get_instance_id()
	print('[Client] Getting peers for callback with ID ', callback_id)
	CALLBACKS[callback_id] = callback
	rpc_id(1, '_get_peers', callback_id, peer_id)


remote func _response(callback_id: int, response) -> void:
	print('[Client] Response received for callback ', callback_id)
	CALLBACKS[callback_id].call_func(response)
	CALLBACKS.erase(callback_id)


func _on_connection_closed() -> void:
	print('[Client] Connection closed')
	emit_signal('connection_closed')
	close()


func _on_connection_failed() -> void:
	print('[Client] Failed to connect')
	emit_signal('connection_failed')
	close()


func _on_connection_success() -> void:
	peer_id = multiplayer.get_network_unique_id()
	print('[Client] Connected with ID ', peer_id)
	get_host_id(funcref(self, '_set_host_id'))
	emit_signal('connected')


func _on_peer_connected(peer_id: int) -> void:
	print('[Client] Peer connected with ID ', peer_id)
	emit_signal('peer_connected', peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	print('[Client] Peer disconnected with ID ', peer_id)
	emit_signal('peer_disconnected', peer_id)


remote func _peer_list_updated() -> void:
	print('[Client] Server peer list updated')
	emit_signal('peer_list_updated')


func _set_host_id(id: int) -> void:
	print('[Client] Setting host ID to ', id)
	host_id = id
