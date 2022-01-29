extends Control


onready var Main = get_node('/root/Main')
onready var ReturnButton = $Panel/ReturnButton
onready var SettingsButton = $Panel/SettingsButton
onready var ExitMenuButton = $Panel/ExitMenuButton
onready var ExitGameButton = $Panel/ExitGameButton


func _ready():
	ReturnButton.connect('pressed', self, '_on_click_return')
	SettingsButton.connect('pressed', self, '_on_click_settings')
	ExitMenuButton.connect('pressed', self, '_on_click_exit_menu')
	ExitGameButton.connect('pressed', self, '_on_click_exit_game')


func _exit_tree():
	ReturnButton.disconnect('pressed', self, '_on_click_return')
	SettingsButton.disconnect('pressed', self, '_on_click_settings')
	ExitMenuButton.disconnect('pressed', self, '_on_click_exit_menu')
	ExitGameButton.disconnect('pressed', self, '_on_click_exit_game')


func _on_click_return():
	Menu.close('Pause')


func _on_click_settings():
	Menu.open('Settings')


func _on_click_exit_menu():
	Menu.close('Pause')
	Client.close()
	Server.close()
	Main.mount_title()


func _on_click_exit_game():
	get_tree().quit()
