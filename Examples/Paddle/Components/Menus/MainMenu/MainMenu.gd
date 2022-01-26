extends Control


func _ready():
	$PlayButton.connect('pressed', self, '_on_click_play')
	$HostButton.connect('pressed', self, '_on_click_host')
	$JoinButton.connect('pressed', self, '_on_click_join')
	$SettingsButton.connect('pressed', self, '_on_click_settings')
	$ExitButton.connect('pressed', self, '_on_click_exit')


func _exit_tree():
	$PlayButton.disconnect('pressed', self, '_on_click_play')
	$HostButton.disconnect('pressed', self, '_on_click_host')
	$JoinButton.disconnect('pressed', self, '_on_click_join')
	$SettingsButton.disconnect('pressed', self, '_on_click_settings')
	$ExitButton.disconnect('pressed', self, '_on_click_exit')


func _on_click_play():
	pass


func _on_click_host():
	pass


func _on_click_join():
	pass


func _on_click_settings():
	pass


func _on_click_exit():
	get_tree().quit()
