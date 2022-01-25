extends Node


func _ready():
	Server.create()
	Client.create()
	
	var control_fire = Config.get('user/controls/fire')
	print('[Main] Config.get(user/controls/fire) = ', control_fire)
