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
	_start()


func _register_audio():
	Audio.add_bus('Music')
	Audio.add_bus('Effects')
	$Music/MenuMusic.bus = 'Music'
	$Music/GameMusic.bus = 'Music'


func _register_menus():
	for menu in MENUS:
		Menu.register(menu, MENUS[menu])


func _start():
	Menu.open('Main')
	$Music/MenuMusic.play()
