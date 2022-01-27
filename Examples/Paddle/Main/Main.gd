extends Node


var MENUS = {
	Main = 'res://Examples/Paddle/Components/Menus/MainMenu/MainMenu.tscn',
	Host = 'res://Examples/Paddle/Components/Menus/HostMenu/HostMenu.tscn',
	Join = 'res://Examples/Paddle/Components/Menus/JoinMenu/JoinMenu.tscn',
	Lobby = 'res://Examples/Paddle/Components/Menus/LobbyMenu/LobbyMenu.tscn',
	Settings = 'res://Examples/Paddle/Components/Menus/SettingsMenu/SettingsMenu.tscn',
	Pause = 'res://Examples/Paddle/Components/Menus/PauseMenu/PauseMenu.tscn',
}


func _ready():
	_register_audio()
	_register_menus()
	_register_multiplayer()
	_start()


func _register_audio():
	Audio.add_bus('Music')
	Audio.add_bus('Effects')
	$Music/MenuMusic.bus = 'Music'
	$Music/GameMusic.bus = 'Music'


func _register_menus():
	for menu in MENUS:
		Menu.register(menu, MENUS[menu])


func _register_multiplayer():
	Server.create()
	Client.create()


func _start():
	Menu.open('Main')
	$Music/MenuMusic.play()


func _exit_tree():
	_deregister_audio()
	_deregister_menus()
	_deregister_multiplayer()


func _deregister_audio():
	Audio.remove_bus('Music')
	Audio.remove_bus('Effects')


func _deregister_menus():
	for menu in MENUS:
		Menu.register(menu, MENUS[menu])


func _deregister_multiplayer():
	Server.close()
	Client.close()
