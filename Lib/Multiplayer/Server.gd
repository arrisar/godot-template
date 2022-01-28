extends 'Multiplayer.gd'


signal peer_connected(peer_id)
signal peer_disconnected(peer_id)
signal peer_list_updated()


var PEERS: Dictionary
var STATE: Dictionary

var host_id: int
var max_players: int
var port: int
var password: String


func _ready() -> void:
	_connect()
	reset()


func _exit_tree() -> void:
	_disconnect()


func _connect() -> void:
	multiplayer.connect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.connect('network_peer_disconnected', self, '_on_peer_disconnected')


func _disconnect() -> void:
	multiplayer.disconnect('network_peer_connected', self, '_on_peer_connected')
	multiplayer.disconnect('network_peer_disconnected', self, '_on_peer_disconnected')


func create() -> void:
	print('[Server] Creating')
	_create_server(port, max_players)


func close(wait: int = 0) -> void:
	print('[Server] Closing')
	reset()
	.close(wait)


func reset() -> void:
	print('[Server] Resetting')
	PEERS.clear()
	STATE.clear()
	host_id = 0
	max_players = 32
	port = 2774
	password = ''


func _on_peer_connected(peer_id: int) -> void:
	print('[Server] Peer connected with ID ', peer_id)
	if host_id == 0: host_id = peer_id
	PEERS[peer_id] = { is_host = host_id == peer_id }
	emit_signal('peer_connected', peer_id)
	emit_signal('peer_list_updated')
	rpc('_peer_list_updated')


func _on_peer_disconnected(peer_id: int) -> void:
	print('[Server] Peer disconnected with ID ', peer_id)
	PEERS.erase(peer_id)
	emit_signal('peer_disconnected', peer_id)
	emit_signal('peer_list_updated')
	rpc('_peer_list_updated')


remote func _get_peers(callback_id: int, peer_id: int = 0) -> void:
	print('[Server] Peer request received with ID ', callback_id)
	var sender_id = multiplayer.get_rpc_sender_id()
	var response: Dictionary = PEERS[peer_id] if peer_id > 1 else PEERS
	rpc_id(sender_id, '_response', callback_id, response)


remote func _set_peer_state(peer_id: int, state: Dictionary) -> void:
	var sender_id = multiplayer.get_rpc_sender_id()
	print('[Server] Received set peer state request for peer %s from sender %s' % [peer_id, sender_id])
	if sender_id != peer_id: return
	
	var allowed_fields = ['name']
	for field in state:
		if field in allowed_fields:
			PEERS[peer_id][field] = state[field]
	
	emit_signal('peer_list_updated')
	rpc('_peer_list_updated')
