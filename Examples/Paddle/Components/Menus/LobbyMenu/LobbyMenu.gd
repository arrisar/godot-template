extends Control


onready var Main = get_node('/root/Main')
onready var PlayerList = $Panel/PlayerList
onready var StartButton = $Panel/StartButton
onready var LeaveButton = $Panel/LeaveButton


func _ready() -> void:
	_connect()
	_get_peers()


func _connect() -> void:
	StartButton.connect('pressed', self, '_on_click_start')
	LeaveButton.connect('pressed', self, '_exit_lobby')
	Client.connect('connection_closed', self, '_exit_lobby')
	Client.connect('peer_list_updated', self, '_get_peers')
	Client.connect('event', self, '_client_event')


func _exit_tree() -> void:
	StartButton.disconnect('pressed', self, '_on_click_start')
	LeaveButton.disconnect('pressed', self, '_exit_lobby')
	Client.disconnect('connection_closed', self, '_exit_lobby')
	Client.disconnect('peer_list_updated', self, '_get_peers')
	Client.disconnect('event', self, '_client_event')


func _exit_lobby() -> void:
	Client.close()
	Server.close()
	Menu.close('Lobby')


func _get_peers() -> void:
	Client.get_peers(funcref(self, '_update_peers'))


func _update_peers(peers: Dictionary) -> void:
	StartButton.disabled = true
	PlayerList.clear()
	
	var i: int = 0
	for id in peers:
		if !peers[id].has('name'):
			continue
			
		if peers[id].is_host:
			PlayerList.add_item(peers[id].name + ' (Host)')
			PlayerList.move_item(i, 0)
		else:
			PlayerList.add_item(peers[id].name)

		i += 1
	
	
	if Client.host_id == Client.peer_id && PlayerList.get_item_count() > 1:
		StartButton.disabled = false


func _on_click_start() -> void:
	Client.send_event('start_game', null)


func _client_event(event: String, _payload) -> void:
	if event == 'start_game' && Client.get_sender_id() == 1:
		Main.mount_game()
