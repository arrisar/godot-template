extends Node


onready var Game = preload('res://Examples/Paddle/Components/Game/Game.tscn')
var MENUS = {
	Main = 'res://Examples/Paddle/Components/Menus/MainMenu/MainMenu.tscn',
	Host = 'res://Examples/Paddle/Components/Menus/HostMenu/HostMenu.tscn',
	Join = 'res://Examples/Paddle/Components/Menus/JoinMenu/JoinMenu.tscn',
	Lobby = 'res://Examples/Paddle/Components/Menus/LobbyMenu/LobbyMenu.tscn',
	Settings = 'res://Examples/Paddle/Components/Menus/SettingsMenu/SettingsMenu.tscn',
	Pause = 'res://Examples/Paddle/Components/Menus/PauseMenu/PauseMenu.tscn',
}


func _ready():
	Server.connect('event', self, '_server_event')
	_register_audio()
	_register_menus()
	mount_title()


func _exit_tree():
	Server.disconnect('event', self, '_server_event')
	Server.close()
	Client.close()


func _register_audio():
	Audio.add_bus('Music')
	Audio.add_bus('Effects')
	$Music/MenuMusic.bus = 'Music'
	$Music/GameMusic.bus = 'Music'


func _register_menus():
	for menu in MENUS:
		Menu.register(menu, MENUS[menu])


func mount_title():
	_unmount_game()
	Menu.close_all()
	Menu.open('Main')
	$Music/MenuMusic.play()
	$Music/GameMusic.stop()

func mount_game():
	_unmount_game()
	var instance = Game.instance()
	instance.name = 'Game'
	add_child(instance)
	Menu.close_all()
	$Music/MenuMusic.stop()
	$Music/GameMusic.play()

func _unmount_game():
	if has_node('Game'):
		$Game.queue_free()


func _server_event(event: String, payload):
	if event == 'start_game' && Server.get_sender_id() == Server.host_id:
		Server.send_event('start_game', null)
