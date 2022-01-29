extends Object


var PLAYERS: Dictionary
var POSITIONS: Dictionary


func start():
	Server.connect('event', self, '_server_event')
	Server.connect('peer_list_updated', self, '_setup_players')
	Server.connect('process', self, '_process')
	_setup_players()


func stop():
	Server.disconnect('event', self, '_server_event')
	Server.disconnect('peer_list_updated', self, '_setup_players')
	Server.disconnect('process', self, '_process')
	PLAYERS.clear()
	POSITIONS.clear()


func _setup_players():
	var i: int = -1
	
	for id in PLAYERS.keys():
		if !Server.PEERS.has(id):
			PLAYERS.erase(id)
	
	for peer in Server.PEERS.values():
		i += 1
		PLAYERS[peer.id] = {
			name = peer.name if peer.has('name') else '',
			paddle = i if i < 2 else null,
			score = 0,
		}
	
	POSITIONS = {
		paddles = [300, 300],
		ball = Vector2(512, 340),
	}
	
	Server.send_event('players_updated', PLAYERS)


func _server_event(event, payload):
	var sender_id = Server.get_sender_id()
	
	match event:
		'player_position_updated':
			var paddle: int = PLAYERS[sender_id].paddle
			if paddle != null:
				POSITIONS.paddles[paddle] = payload


func _process(delta):
	Server.send_event('positions_updated', POSITIONS, true)
