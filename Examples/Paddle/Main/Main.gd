extends Node


func _ready():
	_init_audio()
	_init_menus()
	_init_multiplayer()
	_start()


func _init_audio():
	Audio.add_bus('Music')
	Audio.add_bus('Effects')
	$Music/MenuMusic.bus = 'Music'
	$Music/GameMusic.bus = 'Music'


func _init_menus():
	Menu.register('Main', 'res://Examples/Paddle/Components/Menus/MainMenu/MainMenu.tscn')
	Menu.register('Settings', 'res://Examples/Paddle/Components/Menus/SettingsMenu/SettingsMenu.tscn')
	Menu.register('Host', 'res://Examples/Paddle/Components/Menus/HostMenu/HostMenu.tscn')
	Menu.register('Join', 'res://Examples/Paddle/Components/Menus/JoinMenu/JoinMenu.tscn')
	Menu.register('Lobby', 'res://Examples/Paddle/Components/Menus/LobbyMenu/LobbyMenu.tscn')
	Menu.register('Pause', 'res://Examples/Paddle/Components/Menus/PauseMenu/PauseMenu.tscn')


func _init_multiplayer():
	Server.create()
	Client.create()


func _start():
	Menu.open('Main')
	$Music/MenuMusic.play()
