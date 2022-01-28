extends Control


onready var JoinButton = $Panel/JoinButton
onready var BackButton = $Panel/BackButton
onready var ErrorMessage = $Panel/ErrorMessage

onready var NameInput = $Panel/NameInput
onready var HostInput = $Panel/HostInput
onready var PortInput = $Panel/PortInput
onready var PasswordInput = $Panel/PasswordInput


func _ready():
	_connect()
	NameInput.text = Config.get('user/general/name', 'Player 1')
	HostInput.text = Config.get('system/multiplayer/host', Client.host)
	PortInput.text = str(Config.get('system/multiplayer/port', Client.port))
	PasswordInput.text = Config.get('system/multiplayer/password', '')


func _connect():
	Client.connect('connected', self, '_on_connected')
	Client.connect('connection_failed', self, '_on_connection_failed')
	JoinButton.connect('pressed', self, '_on_click_join')
	BackButton.connect('pressed', self, '_on_click_back')
	NameInput.connect('text_changed', self, '_on_name_changed')
	HostInput.connect('text_changed', self, '_on_host_changed')
	PortInput.connect('text_changed', self, '_on_port_changed')
	PasswordInput.connect('text_changed', self, '_on_password_changed')


func _exit_tree():
	Client.disconnect('connected', self, '_on_connected')
	Client.disconnect('connection_failed', self, '_on_connection_failed')
	JoinButton.disconnect('pressed', self, '_on_click_join')
	BackButton.disconnect('pressed', self, '_on_click_back')
	NameInput.disconnect('text_changed', self, '_on_name_changed')
	HostInput.disconnect('text_changed', self, '_on_host_changed')
	PortInput.disconnect('text_changed', self, '_on_port_changed')
	PasswordInput.disconnect('text_changed', self, '_on_password_changed')


func _disable():
	JoinButton.disabled = true
	BackButton.disabled = true
	NameInput.editable = false
	HostInput.editable = false
	PortInput.editable = false
	PasswordInput.editable = false


func _enable():
	JoinButton.disabled = false
	BackButton.disabled = false
	NameInput.editable = true
	HostInput.editable = true
	PortInput.editable = true
	PasswordInput.editable = true


func _on_click_join():
	ErrorMessage.visible = false
	Client.create()
	Config.save()
	_disable()


func _on_click_back():
	Config.save()
	Menu.close('Join')


func _on_name_changed(text):
	Config.set('user/general/name', text)


func _on_host_changed(text):
	Config.set('system/multiplayer/host', text)
	Client.host = text


func _on_port_changed(text):
	Config.set('system/multiplayer/port', int(text))
	Client.port = int(text)


func _on_password_changed(text):
	Config.set('system/multiplayer/password', text)
	Client.password = text


func _on_connected() -> void:
	Client.set_own_state({ name = NameInput.text })
	Menu.close('Join')
	Menu.open('Lobby')


func _on_connection_failed() -> void:
	ErrorMessage.text = 'Failed to connect'
	ErrorMessage.visible = true
	_enable()
