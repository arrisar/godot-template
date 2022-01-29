extends Control


onready var Main = get_node('/root/Main')


func _ready():
	Server.connect('peer_connected', self, '_on_connected')
	$PlayButton.connect('pressed', self, '_on_click_play')
	$HostButton.connect('pressed', self, '_on_click_host')
	$JoinButton.connect('pressed', self, '_on_click_join')
	$SettingsButton.connect('pressed', self, '_on_click_settings')
	$ExitButton.connect('pressed', self, '_on_click_exit')


func _exit_tree():
	Server.disconnect('peer_connected', self, '_on_connected')
	$PlayButton.disconnect('pressed', self, '_on_click_play')
	$HostButton.disconnect('pressed', self, '_on_click_host')
	$JoinButton.disconnect('pressed', self, '_on_click_join')
	$SettingsButton.disconnect('pressed', self, '_on_click_settings')
	$ExitButton.disconnect('pressed', self, '_on_click_exit')


func _on_click_play():
	Server.create()
	Client.create()


func _on_click_host():
	Menu.open('Host')


func _on_click_join():
	Menu.open('Join')


func _on_click_settings():
	Menu.open('Settings')


func _on_click_exit():
	get_tree().quit()


func _on_connected(_peer_id):
	print('[MainMenu] Connected')
	Client.set_own_state({ name = Config.get('user/general/name', 'Player') })
	Menu.close('Main')
	Main.mount_game()
