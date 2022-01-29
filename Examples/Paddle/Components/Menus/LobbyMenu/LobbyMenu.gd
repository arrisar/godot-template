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


func _exit_tree() -> void:
	StartButton.disconnect('pressed', self, '_on_click_start')
	LeaveButton.disconnect('pressed', self, '_exit_lobby')
	Client.disconnect('connection_closed', self, '_exit_lobby')
	Client.disconnect('peer_list_updated', self, '_get_peers')


func _exit_lobby() -> void:
	Client.close()
	Server.close()
	Menu.close('Lobby')


func _get_peers() -> void:
	Client.get_peers(funcref(self, '_update_peers'))


func _update_peers(peers: Dictionary) -> void:
	PlayerList.clear()
	
	var i: int = 0
	for id in peers:
		if !peers[id].has('name'):
			continue
			
		if peers[id].is_host:
			PlayerList.add_item(peers[id].name + ' (Host)')
			PlayerList.move_item(i, 0)
			if id == Client.peer_id:
				StartButton.disabled = false
		else:
			PlayerList.add_item(peers[id].name)
			StartButton.disabled = true

		i += 1


func _on_click_start() -> void:
	Main.mount_game()
	Menu.close('Lobby')
	Menu.close('Main')
