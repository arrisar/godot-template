extends Control


onready var HostButton = $Panel/HostButton
onready var BackButton = $Panel/BackButton

onready var NameInput = $Panel/NameInput
onready var PortInput = $Panel/PortInput
onready var MaxPlayersInput = $Panel/MaxPlayersInput
onready var PasswordInput = $Panel/PasswordInput


func _ready():
	_connect()
	NameInput.text = Config.get('user/general/name', 'Player 1')
	PortInput.text = str(Config.get('system/multiplayer/port', Server.port))
	MaxPlayersInput.value = Config.get('system/multiplayer/max_players', Server.max_players)
	PasswordInput.text = Config.get('system/multiplayer/password', '')


func _connect():
	Client.connect('connected', self, '_on_connected')
	HostButton.connect('pressed', self, '_on_click_host')
	BackButton.connect('pressed', self, '_on_click_back')
	NameInput.connect('text_changed', self, '_on_name_changed')
	PortInput.connect('text_changed', self, '_on_port_changed')
	MaxPlayersInput.connect('value_changed', self, '_on_max_players_changed')
	PasswordInput.connect('text_changed', self, '_on_password_changed')


func _exit_tree():
	Client.disconnect('connected', self, '_on_connected')
	HostButton.disconnect('pressed', self, '_on_click_host')
	BackButton.disconnect('pressed', self, '_on_click_back')
	NameInput.disconnect('text_changed', self, '_on_name_changed')
	PortInput.disconnect('text_changed', self, '_on_port_changed')
	MaxPlayersInput.disconnect('value_changed', self, '_on_max_players_changed')
	PasswordInput.disconnect('text_changed', self, '_on_password_changed')


func _disable():
	HostButton.disabled = true
	BackButton.disabled = true
	NameInput.editable = false
	PortInput.editable = false
	MaxPlayersInput.editable = false
	PasswordInput.editable = false


func _enable():
	HostButton.disabled = false
	BackButton.disabled = false
	NameInput.editable = true
	PortInput.editable = true
	MaxPlayersInput.editable = true
	PasswordInput.editable = true


func _on_click_host():
	Config.save()
	Server.create()
	Client.reset()
	Client.port = Server.port
	Client.create()
	_disable()


func _on_click_back():
	Config.save()
	Menu.close('Host')


func _on_name_changed(text):
	Config.set('user/general/name', text)


func _on_port_changed(text):
	Config.set('system/multiplayer/port', int(text))
	Server.port = int(text)


func _on_max_players_changed(value):
	Config.set('system/multiplayer/max_players', value)
	Server.max_players = value


func _on_password_changed(text):
	Config.set('system/multiplayer/password', text)
	Server.password = text


func _on_connected():
	Client.set_own_state({ name = NameInput.text })
	Menu.close('Host')
	Menu.open('Lobby')
