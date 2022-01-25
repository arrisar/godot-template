extends Node


func _ready():
	Server.create()
	Client.create()
	
	Audio.add_bus('Foo')
	print(Audio.get_volume('Foo'))
